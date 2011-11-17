#import "Game.h" 

@implementation Game

- (id)init
{
    if ((self = [super init]))
    {
        // this is where the code of your game will start. 
        // in this sample, we add just a simple quad to see if it works.
        
        SPQuad *quad = [SPQuad quadWithWidth:100 height:100];
        quad.color = 0xff0000;
        quad.x = 50;
        quad.y = 50;
        [self.sprite addChild:quad];

    }
    return self;
}
@end
