#import "SubObjectMode.h"
#import "Square.h"
#import "SPEventDispatcher+BlockListener.h"

#import "BTModeStack.h"

@implementation SubObjectMode {
    int _ticks, _squaresRemoved, _squaresAdded;
}

- (Square*) createAndMonitorSquareWithColor:(int)color andName:(NSString*)name {
    Square *square = [[Square alloc] initWithColor:color andName:name];
    [square.conns onReactor:square.onAttached connectUnit:^ { _squaresAdded++; }];
    [square.conns onReactor:square.detached connectUnit:^ { _squaresRemoved++; }];
    return square;
}

- (id)init {
    if (!(self = [super init])) return nil;
    NSAssert(nil == [self nodesForGroup:@"squares"], @"Incorrect squares in group");
    [self addNode:[self createAndMonitorSquareWithColor:0xff0000 andName:@"red"] 
                   displayOn:self.sprite];
    NSAssert(1 == [[self nodesForGroup:@"squares"] count], @"Incorrect squares in group");
    [self.update withPriority:SQUARE_FRAME_PRIORITY + 1 connectUnit:^ {
        if (++_ticks == 2) {
            Square *green = [self createAndMonitorSquareWithColor:0x00ff00 andName:@"green"];
            [((BTObject*)[self nodeForKey:@"red"]) addNode:green];
            [self.sprite addChild:green.display];
            NSAssert(_squaresAdded == 2, @"Second square not added");
            NSAssert(_squaresRemoved == 0, @"Squares removed too early");
            NSAssert(2 == [[self nodesForGroup:@"squares"] count], @"Incorrect squares in group");
        } else if (_ticks == 3) {
            NSAssert(_squaresRemoved == 2, @"Squares not removed");
            NSAssert(nil == [self nodesForGroup:@"squares"], @"Squares not removed from group");
            NSAssert(nil == [self nodeForKey:@"red"], @"Square key not cleared");
        } else if (_ticks == 4) {
            [_stack popMode];
        }
    }];
    return self;
}

@synthesize squaresAdded=_squaresAdded;

@end
