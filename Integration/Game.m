#import "Game.h" 
#import "Square.h"

@implementation Game

- (Square*) createAndMonitorSquareWithColor:(int)color andName:(NSString*)name {
    Square *square = [[Square alloc] initWithColor:color andName:name];
    OBSERVE(square, @"added", { _squaresAdded++; });
    OBSERVE(square, @"removed", { _squaresRemoved++; });
    return square;
}

- (void)runTest {
    _ticks = _squaresAdded = _squaresRemoved = 0;
    [self addObject:[self createAndMonitorSquareWithColor:0xff0000 andName:@"red"]];
}

- (void)advanceTime:(double)seconds {
    [super advanceTime:seconds];
    if (++_ticks == 2) {
        [[self objectForName:@"red"] addDependentObject:[self createAndMonitorSquareWithColor:0x00ff00 andName:@"green"]];
        NSAssert(_squaresAdded == 2, @"Second square not added");
        NSAssert(_squaresRemoved == 0, @"Squares removed too early");
    } else if (_ticks == 3) {
        NSAssert(_squaresRemoved == 2, @"Squares not removed");
    } else if (_ticks == 4) {
        NSLog(@"Named and dependendent objects passed");
    }
}

@synthesize squaresAdded=_squaresAdded;

@end
