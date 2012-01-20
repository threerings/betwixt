//
// gulp - Copyright 2012 Three Rings Design

/**
 * Loads resources from an XML description and adds them to the ResourceManager.
 */
@interface BTResourceGroup : NSObject {
@protected
    NSString *_filename;
    NSString *_xmlString;
    NSString *_name;
}

@property(nonatomic,readonly) NSString *name;

- (id)initWithFilename:(NSString *)filename;
- (id)initWithName:(NSString *)name xml:(NSString *)xmlString;
- (NSArray *)load;

@end
