//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTInterpolator : NSObject

- (float)interpolate:(float)from to:(float)to dt:(float)dt t:(float)t;

+ (BTInterpolator*)LINEAR;
+ (BTInterpolator*)EASE_IN;
+ (BTInterpolator*)EASE_OUT;
+ (BTInterpolator*)EASE_IN_OUT;

@end