//
//  gulp - Copyright 2012 Three Rings Design

#import "GUResource.h"

@implementation GUResource

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
