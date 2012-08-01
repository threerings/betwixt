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

+ (float)getLineWidth:(SPSprite *)line
{
    float lineWidth = 0;
    if (line.numChildren != 0)
    {
        SPDisplayObject *lastChar = [line childAtIndex:line.numChildren-1];
        lineWidth = lastChar.x + lastChar.width;
    }
    return lineWidth;
}

- (SPDisplayObject*)createDisplayObjectWithMaxWidth:(float)maxWidth maxHeight:(float)maxHeight
                                               text:(NSString*)text fontSize:(float)size
                                              color:(uint)color hAlign:(SPHAlign)hAlign
                                             border:(BOOL)border kerning:(BOOL)kerning
{
    if (size == SP_NATIVE_FONT_SIZE) size = mSize;

    float scale = size / mSize;
    maxWidth = (maxWidth < FLT_MAX ? maxWidth / scale : FLT_MAX);
    maxHeight = (maxHeight < FLT_MAX ? maxHeight / scale : FLT_MAX);

    int lastWhiteSpace = -1;
    int lastCharID = -1;
    float currentX = 0;

    float totalWidth = 0;
    float totalHeight = 0;

    SPSprite *lineContainer = [SPSprite sprite];
    lineContainer.scaleX = lineContainer.scaleY = scale;
    SPSprite *currentLine = [SPSprite sprite];

    for (int i = 0; i < text.length; ++i)
    {
        BOOL lineFull = NO;

        int charID = [text characterAtIndex:i];
        if (charID == CHAR_NEWLINE)
        {
            lineFull = YES;
        }
        else
        {
            if (charID == CHAR_SPACE || charID == CHAR_TAB)
                lastWhiteSpace = i;

            SPBitmapChar *bitmapChar = GET_CHAR(charID);

            if (kerning)
                currentX += [bitmapChar kerningToChar:lastCharID];

            SPImage *charImage = [bitmapChar createImage];
            charImage.x = currentX + bitmapChar.xOffset;
            charImage.y = bitmapChar.yOffset;

            charImage.color = color;
            [currentLine addChild:charImage];

            currentX += bitmapChar.xAdvance;
			lastCharID = charID;

            if (currentX > maxWidth)
            {
                lineFull = YES;
                // remove characters and add them again to next line
                int numCharsToRemove = lastWhiteSpace == -1 ? 1 : i - lastWhiteSpace;
                int removeIndex = currentLine.numChildren - numCharsToRemove;

                for (int i=0; i<numCharsToRemove; ++i)
                    [currentLine removeChildAtIndex:removeIndex];

                if (currentLine.numChildren == 0)
                    break;

                SPDisplayObject *lastChar = [currentLine childAtIndex:currentLine.numChildren-1];
                currentX = lastChar.x + lastChar.width;

                i -= numCharsToRemove;
            }
        }

        if (lineFull || i == text.length - 1)
        {
            totalWidth = MAX([SPBitmapFont getLineWidth:currentLine] * scale, totalWidth);
            totalHeight += (mLineHeight * scale);

            [lineContainer addChild:currentLine];

            if (totalHeight < maxHeight)
            {
                currentLine = [SPSprite sprite];
                currentLine.y = totalHeight;

                currentX = 0;
                lastWhiteSpace = -1;
                lastCharID = -1;
            }
            else
            {
                break;
            }
        }
    }

    // hAlign
    if (hAlign != SPHAlignLeft)
    {
        for (SPSprite* line in lineContainer)
        {
            float lineWidth = [SPBitmapFont getLineWidth:line];
            float widthDiff = (totalWidth / scale) - lineWidth;
            line.x = (int) (hAlign == SPHAlignRight ? widthDiff : widthDiff / 2);
        }
    }

    SPSprite *outerContainer = [SPCompiledSprite sprite];
    [outerContainer addChild:lineContainer];

    if (border)
    {
        SPQuad *topBorder = [SPQuad quadWithWidth:totalWidth height:1];
        SPQuad *bottomBorder = [SPQuad quadWithWidth:totalWidth height:1];
        SPQuad *leftBorder = [SPQuad quadWithWidth:1 height:totalHeight-2];
        SPQuad *rightBorder = [SPQuad quadWithWidth:1 height:totalHeight-2];

        topBorder.color = bottomBorder.color = leftBorder.color = rightBorder.color = color;
        bottomBorder.y = totalHeight - 1;
        leftBorder.y = rightBorder.y = 1;
        rightBorder.x = totalWidth - 1;

        [outerContainer addChild:topBorder];
        [outerContainer addChild:bottomBorder];
        [outerContainer addChild:leftBorder];
        [outerContainer addChild:rightBorder];
    }

    return outerContainer;
}

@end
