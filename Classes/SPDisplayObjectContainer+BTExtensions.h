//
// Betwixt - Copyright 2012 Three Rings Design

@interface SPDisplayObjectContainer (BTExtensions)

/// Returns the SPSprite at the given index, or nil if no sprite is at that index
- (SPSprite*)spriteAtIndex:(int)index;

/// Returns the SPSprite with the given name, or nil if no sprite has that name
- (SPSprite*)spriteByName:(NSString*)name;

/// Returns the SPSprite with the given name, or nil if no sprite has that name
- (SPSprite*)spriteByFormatName:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);

/// Returns the SPDisplayObject with the given name
- (SPDisplayObject*)childByFormatName:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);

@end
