//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieCheckbox.h"
#import "BTButton+Protected.h"
#import "BTNode+Protected.h"

#import "BTMovie.h"
#import "BTMovieResource.h"

@implementation BTMovieCheckbox

@synthesize valueChanged = _value;

+ (BTMovieCheckbox*)checkboxWithMovie:(NSString*)movieName {
    return [[BTMovieCheckbox alloc] initWithMovie:[BTMovieResource newMovie:movieName]];
}

- (id)initWithMovie:(BTMovie*)movie {
    if ((self = [super initWithMovie:movie])) {
        _value = [[RABoolValue alloc] init];
    }
    return self;
}

- (void)added {
    [super added];

    [self.conns onReactor:self.clicked connectUnit:^{
        self.value = !self.value;
    }];
}

- (BOOL)value {
    return _value.value;
}

- (void)setValue:(BOOL)value {
    if (_value.value != value) {
        _value.value = value;
        [self displayState:_curState];
    }
}

- (void)displayState:(BTButtonState)state {
    [_movie gotoFrame:state + (_value.value ? 0 : 3)];
}

@end
