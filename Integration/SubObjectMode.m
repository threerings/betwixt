#import "SubObjectMode.h"
#import "Square.h"
#import "SPEventDispatcher+BlockListener.h"

#import "BTModeStack.h"

@implementation SubObjectMode {
    int _ticks, _squaresRemoved, _squaresAdded, _id;
}

- (Square*) createAndMonitorSquareWithColor:(int)color andName:(NSString*)name {
    Square *square = [[Square alloc] initWithColor:color andName:name];
    [square.attached inGroup:square.conns connectBlock:^ { _squaresAdded++; }];
    [square.detached inGroup:square.conns connectBlock:^ { _squaresRemoved++; }];
    return square;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _ticks = _squaresAdded = _squaresRemoved = 0;
    [self addObject:[self createAndMonitorSquareWithColor:0xff0000 andName:@"red"]];
    [self.enterFrame connectBlock:^ {
        if (++_ticks == 2) {
            [[self objectForName:@"red"] addObject:[self createAndMonitorSquareWithColor:0x00ff00 andName:@"green"]];
            NSAssert(_squaresAdded == 2, @"Second square not added");
            NSAssert(_squaresRemoved == 0, @"Squares removed too early");
        } else if (_ticks == 3) {
            NSAssert(_squaresRemoved == 2, @"Squares not removed");
        } else if (_ticks == 4) {
            [_stack popMode];
        }
    }];
    return self;
}

@synthesize squaresAdded=_squaresAdded;

@end
