//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTGeneration.h"

@implementation BTGeneration

-(void) addObject:(BTObject *)object {
    if (_head != nil) object->_next = _head;
    _head = object;
    _head->_gen = self;
    [_head addedToGen];
}

-(void) removeObject:(BTObject *)object {
    object->_removed = YES;
}

- (void)advanceTime:(double)seconds {
    // Tick live objects
    for (BTObject *obj = _head; obj != nil; obj = obj->_next) {
        if (obj->_removed) continue;
        [obj advanceTime:seconds];
    }
    // Drop dead ones
    BTObject *prev;
    for (BTObject* obj = _head; obj != nil; obj = obj->_next) {
        if (!obj->_removed) prev = obj;
        else {
            if (obj == _head) _head = _head->_next;
            else prev->_next = obj->_next;
            obj->_next = nil;
            [obj removedFromGen];
        }
    }
}

@end
