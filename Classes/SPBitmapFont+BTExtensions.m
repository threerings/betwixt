//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPBitmapFont+BTExtensions.h"

#define CHAR_SPACE   32
#define CHAR_TAB      9
#define CHAR_NEWLINE 10

#define GET_CHAR(charID) ({ \
    SPBitmapChar* theChar = [self charByID:charID]; \
    if (theChar == nil) theChar = [self charByID:CHAR_SPACE]; \
    theChar; \
})

@implementation SPBitmapFont (BTExtensions)

- (SPPoint*)getSizeForText:(NSString*)text fontSize:(float)fontSize kerning:(BOOL)kerning {
    return [self getSizeForText:text fontSize:fontSize kerning:kerning maxWidth:0];
}

- (SPPoint*)getSizeForText:(NSString*)text fontSize:(float)fontSize kerning:(BOOL)kerning 
                  maxWidth:(float)maxWidth {
    SPPoint* size = [SPPoint point];
    [self layoutTextWithMaxWidth:maxWidth maxHeight:0 text:text fontSize:fontSize color:0 
                          hAlign:SPHAlignLeft kerning:kerning draw:NO outSize:size];
    return size; 
}

- (SPDisplayObject*)createDisplayObjectWithText:(NSString*)text 
                                       fontSize:(float)size 
                                          color:(uint)color
                                        kerning:(BOOL)kerning {
    return [self layoutTextWithMaxWidth:0 maxHeight:0 text:text fontSize:size color:color
                                 hAlign:SPHAlignLeft kerning:kerning draw:YES outSize:nil];
}

- (SPDisplayObject*)createDisplayObjectWithMaxWidth:(float)maxWidth 
                                               text:(NSString*)text 
                                           fontSize:(float)size 
                                              color:(uint)color 
                                             hAlign:(SPHAlign)hAlign 
                                            kerning:(BOOL)kerning {
    return [self layoutTextWithMaxWidth:maxWidth maxHeight:0 text:text fontSize:size color:color
                                 hAlign:hAlign kerning:kerning draw:YES outSize:nil];
}

- (SPDisplayObject*)createDisplayObjectWithMaxWidth:(float)maxWidth 
                                          maxHeight:(float)maxHeight 
                                               text:(NSString*)text 
                                           fontSize:(float)size 
                                              color:(uint)color 
                                             hAlign:(SPHAlign)hAlign
                                            kerning:(BOOL)kerning {
    return [self layoutTextWithMaxWidth:maxWidth maxHeight:maxHeight text:text fontSize:size 
                                  color:color hAlign:hAlign kerning:kerning draw:YES outSize:nil];
}

- (SPDisplayObject*)layoutTextWithMaxWidth:(float)maxWidth 
                                 maxHeight:(float)maxHeight 
                                      text:(NSString*)text 
                                  fontSize:(float)size 
                                     color:(uint)color
                                    hAlign:(SPHAlign)hAlign
                                   kerning:(BOOL)kerning 
                                      draw:(BOOL)draw
                                   outSize:(SPPoint*)outSize {
    
    if (size == SP_NATIVE_FONT_SIZE) {
        size = mSize;
    }
    
    float scale = size / mSize;
    float containerWidth = maxWidth / scale;
    float containerHeight = maxHeight / scale;
    
    BOOL multiline = (containerWidth > 0);
    BOOL hasMaxHeight = (maxHeight > 0);
    
    int lastWhiteSpace = -1;
    int lastCharID = -1;
    float currentX = 0;
    int currentLineStartIdx = 0;
    
    float totalWidth = 0;
    float totalHeight = 0;
    
    SPSprite* lineContainer = nil;
    SPSprite* currentLine = nil;
    if (draw) {
        lineContainer = [SPSprite sprite];
        lineContainer.scaleX = lineContainer.scaleY = scale;
        currentLine = [SPSprite sprite];
    }
    
    for (int ii = 0; ii < text.length; ++ii) {
        BOOL lineFull = NO;
        
        int charID = [text characterAtIndex:ii];    
        if (multiline && charID == CHAR_NEWLINE) {
            lineFull = YES;
            
        } else {
            if (!multiline && charID == CHAR_NEWLINE) {
                charID = CHAR_SPACE;
            }
            
            if (charID == CHAR_SPACE || charID == CHAR_TAB) {     
                lastWhiteSpace = ii;
            }
            
            SPBitmapChar *bitmapChar = GET_CHAR(charID);
            
            if (kerning) {
                currentX += [bitmapChar kerningToChar:lastCharID];
            }
            
            if (draw) {
                SPImage *charImage = [bitmapChar createImage];
                charImage.x = currentX + bitmapChar.xOffset;
                charImage.y = bitmapChar.yOffset;
                
                charImage.color = color;
                [currentLine addChild:charImage];
            }
            
            currentX += bitmapChar.xAdvance;
			lastCharID = charID;
            
            if (multiline && currentX > containerWidth) {
                // remove characters and add them again to next line
                int numCharsToRemove = lastWhiteSpace == -1 ? 1 : ii - lastWhiteSpace;
                int currentLineCharacterCount = (ii - currentLineStartIdx) + 1;
                
                SPBitmapChar* lastBitmapChar = nil;
                for (int jj = ii - numCharsToRemove + 1; jj <= ii; ++jj) {
                    if (draw) {
                        [currentLine removeChildAtIndex:currentLine.numChildren - 1];
                    }
                    
                    int charID = [text characterAtIndex:jj];
                    SPBitmapChar* bitmapChar = GET_CHAR(charID);
                    currentX -= bitmapChar.xAdvance;
                    
                    if (kerning) {
                        if (lastBitmapChar == nil && jj - 1 >= currentLineStartIdx) {
                            SPBitmapChar* lastBitmapChar = GET_CHAR(jj - 1);
                            currentX -= [lastBitmapChar kerningToChar:charID];
                        }
                        
                        lastBitmapChar = bitmapChar;
                    }
                }
                
                currentLineCharacterCount -= numCharsToRemove;
                if (currentLineCharacterCount <= 0) {
                    break;
                }
                
                ii -= numCharsToRemove;
                lineFull = YES;
            }
        }
        
        if (lineFull || ii == text.length - 1) {
            totalWidth = MAX(totalWidth, currentX);
            totalHeight += mLineHeight;
            
            if (draw) {
                [lineContainer addChild:currentLine];
            }
            
            if (!hasMaxHeight || totalHeight <= containerHeight) {
                if (draw) {
                    currentLine = [SPSprite sprite];
                    currentLine.y = totalHeight;
                }
                
                currentX = 0;
                currentLineStartIdx = ii + 1;
                lastWhiteSpace = -1;
                lastCharID = -1;
            }
            else {
                break;
            }
        }
    }
    
    SPSprite* outerContainer = nil;
    if (draw) {
        // hAlign
        if (hAlign != SPHAlignLeft) {
            for (SPSprite* line in lineContainer)  {
                SPDisplayObject* lastChar = [line childAtIndex:line.numChildren-1];
                float lineWidth = lastChar.x + lastChar.width;
                float widthDiff = containerWidth - lineWidth;
                line.x = (int) (hAlign == SPHAlignRight ? widthDiff : widthDiff / 2);
            }
        }
    
        outerContainer = [SPCompiledSprite sprite];
        [outerContainer addChild:lineContainer];
    }
    
    if (outSize != nil) {
        outSize.x = totalWidth;
        outSize.y = totalHeight;
    }
    
    return outerContainer;
}

@end
