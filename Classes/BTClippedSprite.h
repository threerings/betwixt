//
// Betwixt - Copyright 2012 Three Rings Design

// Adapted from https://gist.github.com/1346513
//
//  SHClippedSprite.h
//  Sparrow
//
//  Created by Shilo White on 5/30/11.
//  Copyright 2011 Shilocity Productions. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

@interface BTClippedSprite : SPSprite {
    SPQuad *mClip;
    SPStage *mStage;
    BOOL mClipping;
}

@property (nonatomic,readonly) SPQuad* clip;
@property (nonatomic,assign) BOOL clipping;

+ (BTClippedSprite*)clippedSprite;

@end