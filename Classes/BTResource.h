//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTResource : NSObject {
@package
    NSString* _name;
    NSString* _group;
}

@property(nonatomic,readonly) NSString* name;
@property(nonatomic,readonly) NSString* group;

@end