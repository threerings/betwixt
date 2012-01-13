//
//  gulp - Copyright 2012 Three Rings Design

#import "GULoadable+Protected.h"

/**
 * Loads resources from an XML description and adds them to the ResourceManager.
 */
@interface GUResourceGroup : GULoadable {
@protected
    NSString *_filename;
    NSString *_xmlString;
    NSString *_name;
}

@property(readonly) NSString *name;

- (id)initWithFilename:(NSString *)filename;
- (id)initWithName:(NSString *)name xml:(NSString *)xmlString;

// override from GULoadable
- (void)doLoad;

@end
