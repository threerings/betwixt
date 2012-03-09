//
// Betwixt - Copyright 2012 Three Rings Design

@interface NSString (OOOExtensions)

/// Returns the double represented by the string. 
/// Throws an exception if the string cannot be converted to a double, or contains extra characters.
- (double)requireDoubleValue;

/// Returns the float represented by the string. 
/// Throws an exception if the string cannot be converted to a float, or contains extra characters.
- (float)requireFloatValue;

/// Returns the int represented by the string. 
/// Throws an exception if the string cannot be converted to a int, or contains extra characters.
- (int)requireIntValue;

/// Returns the BOOL represented by the string. 
/// Any capitalization of "true", "yes", "false", or "no" will be converted.
/// Throws an exception if the string cannot be converted to a BOOL, or contains extra characters.
- (BOOL)requireBoolValue;

@end
