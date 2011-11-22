#import <Foundation/Foundation.h>
#import "BTMode.h"

@interface Game : BTMode {
@private
    int _ticks, _squaresAdded, _squaresRemoved;
}

-(void)runTest;

@property(nonatomic) int squaresAdded;
@end
