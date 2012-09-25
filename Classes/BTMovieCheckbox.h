//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieButton.h"

/// A checkbox that uses a six-frame BTMovie as its display
/// Frame 0: BT_ButtonUp, checked
/// Frame 1: BT_ButtonDown, checked
/// Frame 2: BT_ButtonDisabled, checked
/// Frame 3: BT_ButtonUp, unchecked
/// Frame 4: BT_ButtonDown, unchecked
/// Frame 5: BT_ButtonDisabled, unchecked

@interface BTMovieCheckbox : BTMovieButton {
@protected
    RABoolValue* _value;
}

@property (nonatomic,assign) BOOL value;
@property (nonatomic,readonly) RABoolReactor* valueChanged;

+ (BTMovieCheckbox*)checkboxWithMovie:(NSString*)movieName;

- (id)initWithMovie:(BTMovie*)movie;

@end
