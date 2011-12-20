//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTGeneration.h"
#import "BTGeneration+Package.h"
#import "BTModeStack.h"
#import "BTNamed.h"

@implementation BTGeneration {
    RADoubleSignal *_enterFrame;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _children = [[NSMutableSet alloc] init];
    _namedObjects = [NSMutableDictionary dictionary];
    _enterFrame = [[RADoubleSignal alloc] init];
    return self;
}

- (BTNode*)nodeForName:(NSString*)name {
    return [_namedObjects objectForKey:name];
}

- (BTGeneration*) root {
    return self;
}

- (void) detach {
    [_stack popMode];
}

@synthesize enterFrame=_enterFrame;

@end

@implementation BTGeneration (package)

- (void)enterFrame:(SPEnterFrameEvent*)ev {
    [_enterFrame emitEvent:ev.passedTime];
}

- (void)attachNode:(BTNode*)object {
    if ([object conformsToProtocol:@protocol(BTNamed)]) {
        for (NSString *name in ((id<BTNamed>)object).names) {
            NSAssert1(![_namedObjects objectForKey:name], @"Object name '%@' already used", name);
            [_namedObjects setObject:object forKey:name];
        }
    }
    [object.attached emit];
}

@end
