//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTButton.h"

@interface BTSimpleTextButton : BTButton {
    SPSprite* _container;
    SPTextField* _tf;
    SPQuad* _bg;
    SPRectangle* _clickBounds;
}

- (id)initWithText:(NSString*)text fontSize:(float)size;

@end
