//
// Betwixt - Copyright 2012 Three Rings Design

// Adapted from https://gist.github.com/1346513
//
//  SHClippedSprite.m
//  Sparrow
//
//  Created by Shilo White on 5/30/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "BTClippedSprite.h"

@implementation BTClippedSprite

@synthesize clip = mClip;
@synthesize clipping = mClipping;

+ (BTClippedSprite*)clippedSprite {
    return [[BTClippedSprite alloc] init];
}

- (BTClippedSprite*)init {
    if ((self = [super init])) {
        mClip = [[SPQuad alloc] init];
        mClip.visible = NO;
        mClip.width = 0;
        mClip.height = 0;
        [self addChild:mClip];
        mClipping = NO;
    }
    return self;
}

- (void)render:(SPRenderSupport *)support {
    if (mStage == nil) {
        mStage = self.stage;
    }
    
    if (mClipping) {
        glEnable(GL_SCISSOR_TEST);
        SPRectangle *clip = [[mClip boundsInSpace:mStage] intersectionWithRectangle:[self.parent boundsInSpace:mStage]];
        glScissor((clip.x*[SPStage contentScaleFactor]), (mStage.height*[SPStage contentScaleFactor])-(clip.y*[SPStage contentScaleFactor])-(clip.height*[SPStage contentScaleFactor]), (clip.width*[SPStage contentScaleFactor]), (clip.height*[SPStage contentScaleFactor]));
        [super render:support];
        glDisable(GL_SCISSOR_TEST);
    } else {
        [super render:support];
    }
}

- (SPRectangle *)boundsInSpace:(SPDisplayObject *)targetCoordinateSpace {    
    if (mClipping) {
        return [mClip boundsInSpace:targetCoordinateSpace];
    } else {
        return [super boundsInSpace:targetCoordinateSpace];
    }
}

@end

@implementation SPDisplayObject (ClippedHitTest)
- (SPDisplayObject*)hitTestPoint:(SPPoint*)localPoint forTouch:(BOOL)isTouch {
    if (isTouch && (!mVisible || !mTouchable)) return nil;
    
    SPDisplayObject *parent = self.parent;
    while (parent) {
        if ([parent isKindOfClass:[BTClippedSprite class]] && ![[parent boundsInSpace:parent] containsPoint:localPoint])
            return nil;
        parent = parent.parent;
    }
    
    if ([[self boundsInSpace:self] containsPoint:localPoint]) return self; 
    else return nil;
}
@end