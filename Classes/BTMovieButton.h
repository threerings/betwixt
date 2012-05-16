//
// nod - Copyright 2012 Three Rings Design

#import "BTButton.h"

@class BTMovie;

@interface BTMovieButton : BTButton {
    BTMovie* _movie;
    SPRectangle* _clickBounds;
    NSString* _upLabel;
    NSString* _downLabel;
    NSString* _disabledLabel;
}

- (id)initWithMovie:(BTMovie*)movie upLabel:(NSString*)upLabel downLabel:(NSString*)downLabel 
      disabledLabel:(NSString*)disabledLabel;
- (id)initWithMovie:(BTMovie*)movie;

@end
