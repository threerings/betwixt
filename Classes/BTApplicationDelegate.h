//
//  Betwixt - Copyright 2011 Three Rings Design

#import <UIKit/UIKit.h>
#import "BTModeStack.h"

@interface BTApplicationDelegate : NSObject <UIApplicationDelegate> 
{
@private
    UIWindow *_window;
    SPView *_view;
    BTModeStack *_defaultStack;
}

@property(strong, nonatomic) BTModeStack *defaultStack;

@end
