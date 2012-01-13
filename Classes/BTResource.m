//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTResource.h"

@implementation BTResource

@synthesize name=_name;
@synthesize group=_group;

- (id)initWithName:(NSString *)name group:(NSString *)group {
    if (!(self = [super init])) {
        return nil;
    }
    
    _name = name;
    _group = group;
    return self;
}

@end
