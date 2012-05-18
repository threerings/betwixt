//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjects.h"

static BOOL traverseDisplayListInternal (SPDisplayObject* disp, BTTraverseCallback filter, 
                                         BTTraverseCallback callback) {
    if (filter != nil && !filter(disp)) {
        return YES;
    }
    
    if ([disp isKindOfClass:[SPDisplayObjectContainer class]]) {
        SPDisplayObjectContainer* container = (SPDisplayObjectContainer*)disp;
        int numChildren = container.numChildren;
        for (int ii = numChildren - 1; ii >= 0; ii--) {
            SPDisplayObject* child = [container childAtIndex:ii];
            if (!traverseDisplayListInternal(child, filter, callback)) {
                return NO;
            }
        }
    }
    
    return callback(disp);
}

@implementation BTDisplayObjects

+ (SPPoint*)transformPoint:(SPPoint*)pt from:(SPDisplayObject*)from to:(SPDisplayObject*)to {
    return [to globalToLocal:[from localToGlobal:pt]];
}

+ (void)traverseDisplayList:(SPDisplayObject*)root callback:(BTTraverseCallback)callback {
    traverseDisplayListInternal(root, nil, callback);
}

+ (void)traverseDisplayList:(SPDisplayObject*)root withFilter:(BTTraverseCallback)filter 
                   callback:(BTTraverseCallback)callback {
    traverseDisplayListInternal(root, filter, callback);
}

@end
