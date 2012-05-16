//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTUserSettings.h"

@implementation BTUserSettings

- (BOOL)keyExists:(NSString*)key {
    return ([[NSUserDefaults standardUserDefaults] objectForKey:key] != nil);
}

- (BOOL)boolForKey:(NSString*)key defaultValue:(BOOL)defaultValue {
    return ([self keyExists:key] ? 
            [[NSUserDefaults standardUserDefaults] boolForKey:key] : defaultValue);
}

- (void)setBool:(BOOL)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)integerForKey:(NSString*)key defaultValue:(NSInteger)defaultValue {
    return ([self keyExists:key] ? 
            [[NSUserDefaults standardUserDefaults] integerForKey:key] : defaultValue);
}

- (void)setInteger:(NSInteger)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (float)floatForKey:(NSString*)key defaultValue:(float)defaultValue {
    return ([self keyExists:key] ? 
            [[NSUserDefaults standardUserDefaults] floatForKey:key] : defaultValue);
}

- (void)setFloat:(float)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)doubleForKey:(NSString*)key defaultValue:(double)defaultValue {
    return ([self keyExists:key] ? 
            [[NSUserDefaults standardUserDefaults] doubleForKey:key] : defaultValue);
}

- (void)setDouble:(double)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue {
    return ([self keyExists:key] ? 
            [[NSUserDefaults standardUserDefaults] stringForKey:key] : defaultValue);
}

- (void)setString:(NSString*)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
