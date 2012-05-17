//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode.h"

@interface SubObjectMode : BTMode {
@protected
    int _ticks, _squaresRemoved, _squaresAdded;
}
@property(nonatomic) int squaresAdded;
@end
