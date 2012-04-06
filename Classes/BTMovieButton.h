//
// nod - Copyright 2012 Three Rings Design

#import "BTButton.h"

@class BTMovie;

@interface BTMovieButton : BTButton {
    BTMovie* _movie;
    SPRectangle* _clickBounds;
}

- (id)initWithMovie:(BTMovie*)movie;

@end
