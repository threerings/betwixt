//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTNode (protected)

/// Called when the node is attached to the node tree. Subclasses will generally want to
/// perform most of their setup code in attached, rather than in their init function, since
/// it's an error to attach other nodes before this point.
- (void)attached;

/// Called when the node is destroyed - either by being detached during normal gameplay,
/// or when its BTMode is shut down. Subclasses that manage resources should release
/// them in this function. No gameplay code should be run in cleanup.
- (void)cleanup;

/// "Keyed" objects are uniquely identified in their containing BTMode
/// No two nodes can share the same key in a given mode.
/// You can retrieve a keyed node from its mode with [BTMode nodeForKey:]
/// You can use BT_STATIC_KEYS(@"foo", @"bar") for easy implementation.
/// Alternately, if your keys are defined dynamically, you can use BT_KEYS(...)
- (NSArray*)keys;

/// Multiple objects can belong to the same group.
/// You can retrieve all objects in a group with [BTMode nodesForGroup:]
/// You can use BT_STATIC_GROUPS(@"foo", @"bar") for easy implementation.
/// Alternately, if your groups are defined dynamically, you can use BT_GROUPS(...)
- (NSArray*)groups;

@end

#define BT_STATIC_GROUPS(...) \
    static NSMutableArray* gValues = nil;  \
    if (gValues == nil) { \
        gValues = [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]; \
        NSArray* parentGroups = super.groups; \
        if (parentGroups != nil) { [gValues addObjectsFromArray:parentGroups]; } \
    } \
    return gValues;

#define BT_STATIC_KEYS(...) \
    static NSMutableArray* gValues = nil;  \
    if (gValues == nil) { \
        gValues = [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]; \
        NSArray* parentKeys = super.keys; \
        if (parentKeys != nil) { [gValues addObjectsFromArray:parentKeys]; } \
    } \
    return gValues;

#define BT_GROUPS(...) \
    NSMutableArray* values = [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]; \
    NSArray* parentGroups = super.groups; \
    if (parentGroups != nil) { [values addObjectsFromArray:parentGroups]; } \
    return values;

#define BT_KEYS(...) \
    NSMutableArray* values = [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]; \
    NSArray* parentKeys = super.keys; \
    if (parentKeys != nil) { [values addObjectsFromArray:parentKeys]; } \
    return values;
