//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTCheckbox.h"
#import "BTSprite.h"

@class BTButton;

@interface BTCheckbox : BTSprite {
@protected
    RABoolSignal* _valueChanged;
    BTButton* _checkedButton;
    BTButton* _uncheckedButton;
}

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) BOOL value;
@property (nonatomic,readonly) RABoolSignal* valueChanged;

+ (BTCheckbox*)checkboxWithMovie:(NSString*)movieName;

- (id)initWithCheckedButton:(BTButton*)checked uncheckedButton:(BTButton*)unchecked;

@end
