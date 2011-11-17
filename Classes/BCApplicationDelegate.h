#import <UIKit/UIKit.h>
#import "BCModeStack.h"

@interface BCApplicationDelegate : NSObject <UIApplicationDelegate> 
{
@private
    UIWindow *_window;
    SPView *_view;
    BCModeStack *_defaultStack;
}

@property(strong, nonatomic) BCModeStack *defaultStack;

@end
