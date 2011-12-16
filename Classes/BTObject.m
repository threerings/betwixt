//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTObject.h"
#import "BTGeneration.h"
#import "BTGeneration+Package.h"
#import "BTObject+Package.h"

@implementation BTObject

- (NSArray*)names {
    return [NSArray array];
}

- (void)detach {
    [_parent removeObject:self];
}

- (BTGeneration*) root {
    if ([_parent isKindOfClass:[BTObject class]]) return ((BTObject*)_parent).root;
    return (BTGeneration*)_parent;
}

@synthesize parent=_parent;

@end

@implementation BTObject (package)

- (void)removeInternal {
    NSMutableSet *kids = _children;
    _children = nil;
    for (BTObject *child in kids) {
        [child removeInternal];
    }
    _parent = nil;
    [self.detached emit];
}

@end
