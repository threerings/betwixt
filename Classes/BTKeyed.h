//
// Betwixt - Copyright 2012 Three Rings Design

/// "Keyed" objects are uniquely identified in their containing BTMode
/// No two nodes can share the same key in a given mode.
/// You can retrieve a keyed node from its mode with [BTMode nodeForKey:]
@protocol BTKeyed
@property(nonatomic,readonly) NSArray* keys;
@end
