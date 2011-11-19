#import "Game.h" 
#import "Square.h"

@implementation Game

- (id)init {
    if (!(self = [super init])) return nil;
    [self addObject:[[Square alloc] initWithColor:0xff0000]];
    return self;
}

@end
