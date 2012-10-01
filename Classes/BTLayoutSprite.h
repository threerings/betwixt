//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTLayoutSprite : SPSprite
- (void)layoutDisplayObjects:(NSArray*)objects;
@end

@interface BTRowLayoutSprite : BTLayoutSprite {
@protected
    SPVAlign _align;
    float _gap;
}

- (id)initWithVAlign:(SPVAlign)align gap:(float)gap;
@end

@interface BTColumnLayoutSprite : BTLayoutSprite {
@protected
    SPHAlign _align;
    float _gap;
}

- (id)initWithHAlign:(SPHAlign)align gap:(float)gap;
@end