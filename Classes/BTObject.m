//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTObject.h"
#import "BTGeneration.h"

@implementation BTObject

- (id)init {
    if (!(self = [super init])) return nil;
    _tokens = [NSMutableSet set];
    OBSERVE(self, @"removed", {
        // Copy the set before detaching as detaching modifies the set
        for (AMBlockToken *token in [_tokens allObjects]) [self detachObserverForToken:token];
    });
    return self;
}

- (void)addDependentObject:(BTObject*)object {
    object->_next = _depHead;
    _depHead = object;
    [_gen attachObject:object];
}

- (NSArray*)names {
    return [NSArray array];
}

- (AMBlockToken*)attachObserverForKeyPath:(NSString *)path task:(AMBlockTask)task {
    AMBlockToken *token = [self addObserverForKeyPath:path task:task];
    [_tokens addObject:token];
    return token;
}

- (void)detachObserverForToken:(AMBlockToken *)token {
    [self removeObserverWithBlockToken:token];
    [_tokens removeObject:token];
}

- (void)advanceTime:(double)seconds {}

@synthesize added, removed;

@end
