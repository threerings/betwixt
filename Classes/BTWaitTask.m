//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTWaitTask.h"

@implementation BTWaitTask

+ (BTWaitTask *)waitFor:(float)seconds {
    return [[BTWaitTask alloc] initWithTime:seconds];
}

@end