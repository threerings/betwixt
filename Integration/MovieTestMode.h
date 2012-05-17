//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode.h"

@interface MovieTestMode : BTMode {
@protected
    NSString* _resourceName;
    NSString* _movieName;
}

- (id)initWithResourceName:(NSString*)resourceName movieName:(NSString*)movieName;

@end
