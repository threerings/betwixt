#import "Game.h" 
#import "Square.h"

@implementation Game {
    int _ticks, _squaresRemoved, _squaresAdded;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _ticks = 5;
    return self;
}

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
    }
}

@synthesize squaresAdded=_squaresAdded;

@end
