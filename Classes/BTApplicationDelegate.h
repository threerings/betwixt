//
// Betwixt - Copyright 2012 Three Rings Design

#import <UIKit/UIKit.h>
#import "BTModeStack.h"

@interface BTApplicationDelegate : NSObject <UIApplicationDelegate> {
@private
    UIWindow *_window;
}

// Subclasses should override this.
- (void)run:(BTModeStack *)defaultStack;

@end
