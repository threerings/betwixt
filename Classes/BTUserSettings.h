//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTUserSettings : NSObject

- (BOOL)keyExists:(NSString*)key;

- (BOOL)boolForKey:(NSString*)key defaultValue:(BOOL)defaultValue;
- (void)setBool:(BOOL)value forKey:(NSString*)key;

- (NSInteger)integerForKey:(NSString*)key defaultValue:(NSInteger)defaultValue;
- (void)setInteger:(NSInteger)value forKey:(NSString*)key;

- (float)floatForKey:(NSString*)key defaultValue:(float)defaultValue;
- (void)setFloat:(float)value forKey:(NSString*)key;

- (double)doubleForKey:(NSString*)key defaultValue:(double)defaultValue;
- (void)setDouble:(double)value forKey:(NSString*)key;

- (NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;
- (void)setString:(NSString*)value forKey:(NSString*)key;

@end
