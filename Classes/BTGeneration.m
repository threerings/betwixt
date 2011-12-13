//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTGeneration.h"
#import "BTGeneration+Package.h"

@implementation BTGeneration

- (id)init {
    if (!(self = [super init])) return nil;
    _namedObjects = [NSMutableDictionary dictionary];
    return self;
}

- (void)addObject:(BTObject*)object {
    if (_head != nil) object->_next = _head;
    _head = object;
    object->_parent = self;
    [self attachObject:object];
}

- (BTObject*)objectForName:(NSString*)name {
    return [_namedObjects objectForKey:name];
}

- (void)removeObject:(BTObject*)object {
    for (BTObject* obj = object->_depHead; obj != nil; obj = obj->_next) [self removeObject:obj];
    [_namedObjects removeObjectsForKeys:object.names];
    object.removed = YES;
}

BTObject* dropDeadObjects(BTObject *head);
BTObject* dropDeadObjects(BTObject *head) {
    BTObject *prev;
    for (BTObject* obj = head; obj != nil; obj = obj->_next) {
        obj->_depHead = dropDeadObjects(obj->_depHead);
        if (!obj.removed) {
            prev = obj;
        } else {
            if (obj == head) head = head->_next;
            else prev->_next = obj->_next;
            obj->_next = nil;
        }
    }
    return head;
}
@end

@implementation BTGeneration (package)

- (void)enterFrame:(SPEnterFrameEvent*)ev {
    [self dispatchEvent:ev];
    _head = dropDeadObjects(_head);
}

- (void)attachObject:(BTObject*)object {
    for (NSString *name in object.names) {
        NSAssert1(![_namedObjects objectForKey:name], @"Object name '%@' already used", name);
        [_namedObjects setObject:object forKey:name];
    }
    object.added = YES;
}

@end
