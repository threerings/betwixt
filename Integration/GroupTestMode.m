//
// Betwixt - Copyright 2012 Three Rings Design

#import "GroupTestMode.h"
#import "BTMode+Protected.h"
#import "BTObject.h"
#import "BTModeStack.h"

static NSString * GROUP = @"Group";

@interface GroupedObject : BTObject
+ (GroupedObject*)create;
@end
@implementation GroupedObject
+ (GroupedObject*)create { return [[GroupedObject alloc] init]; }
- (NSArray*)groups { return BT_STATIC_GROUPS(GROUP); }
@end

@implementation GroupTestMode

- (void)setup {
    for (int ii = 0; ii < 10; ++ii) {
        [self addNode:[GroupedObject create]];
    }
    
    do {
        int count = 0;
        for (BTNode* node in [self nodesInGroup:GROUP]) {
            count++;
        }
        NSAssert(count == 10, @"Missing grouped nodes");
    } while (0);
    
    do {
        int count = 0;
        for (BTNode* node in [self nodesInGroup:GROUP]) {
            [node detach];
            count++;
        }
        NSAssert(count == 10, @"Missing grouped nodes");
    } while (0);
    
    [self.modeStack popMode];
}

@end
