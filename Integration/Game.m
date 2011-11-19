#import "Game.h" 
#import "Square.h"

@implementation Game

- (id)init {
    if (!(self = [super init])) return nil;
    [self addObject:[[Square alloc] initWithColor:0xff0000 andName:@"red"]];
    return self;
}

int _ticks = 0;

- (void)advanceTime:(double)seconds {
    [super advanceTime:seconds];
    if (++_ticks == 2) {
        [[self objectForName:@"red"] addDependentObject:[[Square alloc] initWithColor:0x00ff00 andName:@"green"]];
        NSAssert(SQUARES_ADDED == 2, @"Second square not added");
        NSAssert(SQUARES_REMOVED == 0, @"Squares removed too early");
    } else if (_ticks == 3) {
        NSAssert(SQUARES_REMOVED == 2, @"Squares not removed");
    } else if (_ticks == 4) {
        NSLog(@"Named and dependendent objects passed");
    }
}

@end
