//
//  gulp - Copyright 2012 Three Rings Design

#import "GULoadable.h"

@class GDataXMLElement;

@interface GUResource : GULoadable {
@protected
    NSString *_name;
    NSString *_group;
}

@property(readonly) NSString *name;
@property(readonly) NSString *group;

- (id)initWithName:(NSString *)name group:(NSString *)group;

@end
