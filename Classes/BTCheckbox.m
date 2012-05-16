//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTCheckbox.h"
#import "BTNode+Protected.h"
#import "BTMovieButton.h"
#import "BTMovieResource.h"

@implementation BTCheckbox

@synthesize valueChanged = _valueChanged;

+ (BTCheckbox*)checkboxWithMovie:(NSString*)movieName {
    BTButton* checked = [[BTMovieButton alloc] initWithMovie:[BTMovieResource newMovie:movieName] 
                                                     upLabel:@"on_up" 
                                                   downLabel:@"on_down" 
                                               disabledLabel:@"on_disabled"];
    BTButton* unchecked = [[BTMovieButton alloc] initWithMovie:[BTMovieResource newMovie:movieName] 
                                                       upLabel:@"off_up" 
                                                     downLabel:@"off_down" 
                                                 disabledLabel:@"off_disabled"];
    return [[BTCheckbox alloc] initWithCheckedButton:checked uncheckedButton:unchecked];
}

- (id)initWithCheckedButton:(BTButton*)checked uncheckedButton:(BTButton*)unchecked {
    if ((self = [super init])) {
        _valueChanged = [[RABoolSignal alloc] init];
        _checkedButton = checked;
        _uncheckedButton = unchecked;
        _checkedButton.display.visible = NO;
        _uncheckedButton.display.visible = YES;
    }
    return self;
}

- (void)attached {
    [super attached];
    [self addNode:_checkedButton displayOn:_sprite];
    [self addNode:_uncheckedButton displayOn:_sprite];
    
    [self.conns onReactor:_checkedButton.clicked connectUnit:^{
        self.value = NO;
    }];
    [self.conns onReactor:_uncheckedButton.clicked connectUnit:^{
        self.value = YES;
    }];
}

- (BOOL)enabled {
    return _checkedButton.enabled;
}

- (void)setEnabled:(BOOL)enabled {
    _checkedButton.enabled = enabled;
    _uncheckedButton.enabled = enabled;
}

- (BOOL)value {
    return _checkedButton.display.visible;
}

- (void)setValue:(BOOL)newValue {
    if (newValue != self.value) {
        _checkedButton.display.visible = newValue;
        _uncheckedButton.display.visible = !newValue;
        [_valueChanged emitEvent:newValue];
    }
}

@end
