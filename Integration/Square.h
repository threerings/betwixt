//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObject.h"
#import "BTUpdatable.h"

#define SQUARE_FRAME_PRIORITY RA_DEFAULT_PRIORITY

@interface Square : BTDisplayObject <BTUpdatable> {
@private
    SPQuad *_quad;
    NSString *_name;
    RAUnitSignal *_attached;
}

@property(nonatomic,readonly) RAUnitSignal* onAttached;

- (id)initWithColor:(int)color andName:(NSString*)name;
- (void)update:(float)dt;

@end
