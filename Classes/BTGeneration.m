//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTGeneration.h"

void advanceLiveObjects(BTObject* head, double seconds);
BTObject* dropDeadObjects(BTObject* head);

@implementation BTGeneration

-(void) addObject:(BTObject *)object {
    if (_head != nil) object->_next = _head;
    _head = object;
    _head->_gen = self;
    [_head addedToGen];
}

-(void) removeObject:(BTObject *)object {
    for (BTObject* obj = object->_depHead; obj != nil; obj = obj->_next) [self removeObject:obj];
    object->_removed = YES;
}

void advanceLiveObjects(BTObject* head, double seconds) {
    for (BTObject *obj = head; obj != nil; obj = obj->_next) {
        if (obj->_removed) continue;
        [obj advanceTime:seconds];
        advanceLiveObjects(obj->_depHead, seconds);
    }
}

BTObject* dropDeadObjects(BTObject* head) {
    BTObject *prev;
    for (BTObject* obj = head; obj != nil; obj = obj->_next) {
        obj->_depHead = dropDeadObjects(obj->_depHead);
        if (!obj->_removed) {
            prev = obj;
        } else {
            if (obj == head) head = head->_next;
            else prev->_next = obj->_next;
            obj->_next = nil;
            [obj removedFromGen];
        }
    }
    return head;
}

- (void)advanceTime:(double)seconds {
    advanceLiveObjects(_head, seconds);
    _head = dropDeadObjects(_head);
}

@end
