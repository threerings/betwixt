//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPTextField+BTExtensions.h"
#import "SPTextField_Internal.h"
#import "SPBitmapFont+BTExtensions.h"

@implementation SPTextField (BTExtensions)

- (id)initWithFormat:(NSString *)text, ... {
    return [self initWithText:OOO_FORMAT_TO_NSSTRING(text)];
}

- (void)autoSizeText:(NSString*)text maxWidth:(float)maxWidth maxHeight:(float)maxHeight {
    mText = text;

    [mContents removeFromParent];

    mContents = (mIsRenderedText ?
                 [self createRenderedContentsWithMaxWidth:maxWidth maxHeight:maxHeight] :
                 [self createComposedContentsWithMaxWidth:maxWidth maxHeight:maxHeight]);

    mContents.touchable = NO;
    mRequiresRedraw = NO;

    [self addChild:mContents];

    mHitArea.width = mTextArea.width;
    mHitArea.height = mTextArea.height;
}

- (void)autoSizeText:(NSString*)text maxWidth:(float)maxWidth {
    [self autoSizeText:text maxWidth:maxWidth maxHeight:FLT_MAX];
}

- (void)autoSizeText:(NSString*)text {
    [self autoSizeText:text maxWidth:FLT_MAX maxHeight:FLT_MAX];
}

- (SPDisplayObject*)createRenderedContentsWithMaxWidth:(float)maxWidth maxHeight:(float)maxHeight {
    float fontSize = mFontSize == SP_NATIVE_FONT_SIZE ? SP_DEFAULT_FONT_SIZE : mFontSize;

    UILineBreakMode lbm = UILineBreakModeTailTruncation;
    CGSize textSize = [mText sizeWithFont:[UIFont fontWithName:mFontName size:fontSize]
                        constrainedToSize:CGSizeMake(maxWidth, maxHeight) lineBreakMode:lbm];

    float width = textSize.width;
    float height = textSize.height;

    mTextArea.x = 0;
    mTextArea.y = 0;
    mTextArea.width = width;
    mTextArea.height = height;

    SPTexture *texture = [[SPTexture alloc] initWithWidth:width height:height
                                                    scale:[SPStage contentScaleFactor]
                                               colorSpace:SPColorSpaceAlpha
                                                     draw:^(CGContextRef context)
                          {
                              if (mBorder)
                              {
                                  CGContextSetGrayStrokeColor(context, 1.0f, 1.0f);
                                  CGContextSetLineWidth(context, 1.0f);
                                  CGContextStrokeRect(context, CGRectMake(0.5f, 0.5f, width-1, height-1));
                              }

                              CGContextSetGrayFillColor(context, 1.0f, 1.0f);

                              [mText drawInRect:CGRectMake(0, 0, width, height)
                                       withFont:[UIFont fontWithName:mFontName size:fontSize]
                                  lineBreakMode:lbm alignment:(UITextAlignment)mHAlign];
                          }];

    SPImage *image = [SPImage imageWithTexture:texture];
    image.color = mColor;

    return image;
}

- (SPDisplayObject*)createComposedContentsWithMaxWidth:(float)maxWidth maxHeight:(float)maxHeight {
    SPBitmapFont *bitmapFont = [SPTextField getRegisteredBitmapFont:mFontName];
    if (!bitmapFont) {
        [NSException raise:SP_EXC_INVALID_OPERATION
                    format:@"bitmap font %@ not registered!", mFontName];
    }

    SPDisplayObject* contents = [bitmapFont createDisplayObjectWithMaxWidth:maxWidth
                                                                  maxHeight:maxHeight
                                                                       text:mText
                                                                   fontSize:mFontSize
                                                                      color:mColor
                                                                     hAlign:mHAlign
                                                                     border:mBorder
                                                                    kerning:mKerning];

    SPRectangle *textBounds = [(SPDisplayObjectContainer *)contents childAtIndex:0].bounds;
    mTextArea.x = textBounds.x; mTextArea.y = textBounds.y;
    mTextArea.width = textBounds.width; mTextArea.height = textBounds.height;

    return contents;
}

@end
