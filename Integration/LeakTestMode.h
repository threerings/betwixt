//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode.h"

@interface LeakTestMode : BTMode {
@protected
    __weak BTObject* _parent;
    __weak BTObject* _child;
    __weak BTObject* _child2;
    __weak Updater* _updater;
    __weak Listener* _listener;
    __weak BTSprite* _sprite;
    __weak BTMovie* _movie;
    int _ticks;
}

@end
