#import "Game.h" 
#import "Square.h"

#import "SPEventDispatcher+BlockListener.h"

@implementation Game {
    int _ticks, _squaresRemoved, _squaresAdded;
}

- (Square*) createAndMonitorSquareWithColor:(int)color andName:(NSString*)name {
    Square *square = [[Square alloc] initWithColor:color andName:name];
    OBSERVE(square, square, @"added", { _squaresAdded++; });
    OBSERVE(square, square, @"removed", { _squaresRemoved++; });
    return square;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _ticks = 5; 
    return self;
}

- (void)runTest {
    _ticks = _squaresAdded = _squaresRemoved = 0;
    [self addObject:[self createAndMonitorSquareWithColor:0xff0000 andName:@"red"]];
    __block OOOBlockToken *token = LISTEN(self, self, SP_EVENT_TYPE_ENTER_FRAME, {
        if (++_ticks == 2) {
            [[self objectForName:@"red"] addDependentObject:[self createAndMonitorSquareWithColor:0x00ff00 andName:@"green"]];
            NSAssert(_squaresAdded == 2, @"Second square not added");
            NSAssert(_squaresRemoved == 0, @"Squares removed too early");
        } else if (_ticks == 3) {
            NSAssert(_squaresRemoved == 2, @"Squares not removed");
        } else if (_ticks == 4) {
            [self removeListenerWithBlockToken:token];
        }
    });
}

@synthesize squaresAdded=_squaresAdded;

@end
