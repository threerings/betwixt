//
// Betwixt - Copyright 2012 Three Rings Design

#import <UIKit/UIKit.h>
#import "TestApp.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        [BTApp registerAppClass:[TestApp class]];
        return UIApplicationMain(argc, argv, nil, @"BTApplicationDelegate");
    }
}