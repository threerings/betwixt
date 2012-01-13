//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTLoadable.h"

@class GDataXMLElement;

@interface BTResource : BTLoadable {
@protected
    NSString *_name;
    NSString *_group;
}

@property(readonly) NSString *name;
@property(readonly) NSString *group;

- (id)initWithName:(NSString *)name group:(NSString *)group;

@end
