//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTModeStack.h"

#import "BTMode+Package.h"
#import "BTMode+Protected.h"

typedef enum {
    kMTT_Push,
    kMTT_Insert,
    kMTT_Remove,
    kMTT_Change,
    kMTT_Unwind
} ModeTransitionType;

@interface PendingModeTransition : NSObject {
@public
    ModeTransitionType type;
    BTMode *mode;
    int index;
}
- (id)init:(ModeTransitionType)theType mode:(BTMode *)theMode index:(int)theIndex;
@end

@implementation PendingModeTransition
- (id)init:(ModeTransitionType)theType mode:(BTMode *)theMode index:(int)theIndex {
    if (!(self = [super init])) {
        return nil;
    }
    type = theType;
    mode = theMode;
    index = theIndex;
    return self;
}
@end

@implementation BTModeStack

- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    _stack = [NSMutableArray array];
    _pendingModeTransitions = [NSMutableArray array];
    return self;
}

- (BTMode *)topMode {
    return (BTMode *)[_stack lastObject];
}

- (void)pushMode:(BTMode*)mode {
    [_pendingModeTransitions addObject:[[PendingModeTransition alloc] init:kMTT_Push mode:mode index:0]];
}

- (void)popMode {
    [self removeModeAt:-1];
}

- (void)changeMode:(BTMode *)mode {
    [_pendingModeTransitions addObject:[[PendingModeTransition alloc] init:kMTT_Change mode:mode index:0]];
}

- (void)insertMode:(BTMode *)mode atIndex:(int)index {
    [_pendingModeTransitions addObject:[[PendingModeTransition alloc] init:kMTT_Insert mode:mode index:index]];
}

- (void)removeModeAt:(int)index {
    [_pendingModeTransitions addObject:[[PendingModeTransition alloc] init:kMTT_Remove mode:nil index:index]];
}

- (void)unwindToMode:(BTMode *)mode {
    [_pendingModeTransitions addObject:[[PendingModeTransition alloc] init:kMTT_Unwind mode:mode index:0]];
}

- (void)clear {
    [_pendingModeTransitions addObject:[[PendingModeTransition alloc] init:kMTT_Unwind mode:nil index:0]];
}

- (void)handleModeTransitions {
    if (_pendingModeTransitions.count == 0) {
        return;
    }
    
    __block BTMode *initialTopMode = self.topMode;
    __weak BTModeStack *this = self;
    
    typedef void (^InsertModeBlock)(BTMode *mode, int index);
    typedef void (^RemoveModeBlock)(int index);
    
    InsertModeBlock doInsertMode = ^(BTMode *newMode, int index) {
        if (index < 0) {
            index = _stack.count + index;
        }
        index = MAX(index, 0);
        index = MIN(index, _stack.count);
        
        if (index == _stack.count) {
            [_stack addObject:newMode];
            [_sprite addChild:newMode.sprite];
        } else {
            [_stack insertObject:newMode atIndex:index];
            [_sprite addChild:newMode.sprite atIndex:index];
        }
        newMode->_stack = this;
    };
    
    RemoveModeBlock doRemoveMode = ^(int index) {
        NSAssert(_stack.count > 0, @"Can't remove from an empty modestack");
        
        if (index < 0) {
            index = _stack.count + index;
        }
        index = MAX(index, 0);
        index = MIN(index, _stack.count - 1);
        
        // if the top mode is removed, make sure it's exited first
        BTMode *removedMode = [_stack objectAtIndex:index];
        if (removedMode == initialTopMode) {
            [initialTopMode exitInternal];
            initialTopMode = nil;
        }
        
        [_stack removeObjectAtIndex:index];
        [_sprite removeChild:removedMode.sprite];
        [removedMode shutdownInternal];
    };
    
    // create a new _pendingModeTransitionQueue right now
    // so that we can properly handle mode transition requests
    // that occur during the processing of the current queue
    NSMutableArray *transitions = _pendingModeTransitions;
    _pendingModeTransitions = [NSMutableArray array];
    
    for (PendingModeTransition *transition in transitions) {
        switch (transition->type) {
            case kMTT_Push:
                doInsertMode(transition->mode, _stack.count);
                break;
                
            case kMTT_Insert:
                doInsertMode(transition->mode, transition->index);
                break;
                
            case kMTT_Remove:
                doRemoveMode(transition->index);
                break;
                
            case kMTT_Change:
                if (_stack.count > 0) {
                    doRemoveMode(-1); // pop
                }
                doInsertMode(transition->mode, _stack.count); // push
                break;
                
            case kMTT_Unwind:
                // pop modes till we find the one we're looking for
                while (_stack.count > 0 && self.topMode != transition->mode) {
                    doRemoveMode(-1);
                }
                
                NSAssert(self.topMode == transition->mode || _stack.count == 0, @"");
                
                if (_stack.count == 0 && transition->mode != nil) {
                    doInsertMode(transition->mode, _stack.count);
                }
                break;
        }
    }
    
    BTMode *newTopMode = self.topMode;
    if (newTopMode != initialTopMode) {
        if (initialTopMode != nil) {
            [initialTopMode exitInternal];
        }
        if (newTopMode != nil) {
            [newTopMode enterInternal];
        }
    }
}

- (void)update:(float)dt {
    [self handleModeTransitions];
    [[_stack lastObject] update:dt];
}

@end
