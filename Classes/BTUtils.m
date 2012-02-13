//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTUtils.h"

id BTNSNullToNil (id obj) { return (obj == [NSNull null] ? nil : obj); }

id BTNilToNSNull (id obj) { return (obj == nil ? [NSNull null] : obj); }

#define COMPARE(a,b) ((a < b ? -1 : (a > b ? 1 : 0)))

int BTCompareInts (int a, int b) { return COMPARE(a,b); }

int BTCompareFloats (float a, float b) { return COMPARE(a,b); }