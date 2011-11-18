#import "Game.h" 
#import "Square.h"

@implementation Game

- (id)init
{
    if (!(self = [super init])) return nil;
    [self addObject:[[Square alloc] init]];
    return self;
}

@end
