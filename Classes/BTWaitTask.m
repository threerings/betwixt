//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTWaitTask.h"

@implementation BTWaitTask

+ (BTWaitTask*)withTime:(float)seconds {
    return [[BTWaitTask alloc] initWithTime:seconds];
}

@end