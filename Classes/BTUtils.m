//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTUtils.h"

id BTNSNullToNil (id obj) { return (obj == [NSNull null] ? nil : obj); }

id BTNilToNSNull (id obj) { return (obj == nil ? [NSNull null] : obj); }

#define BT_COMPARE_NUMBERS(a,b) ((a) > (b) ? 1 : ((a) == (b) ? 0 : -1))

NSComparisonResult BTCompareBooleans (BOOL a, BOOL b) { return BT_COMPARE_NUMBERS(a, b); }
NSComparisonResult BTCompareInts (int a, int b) { return BT_COMPARE_NUMBERS(a, b); }
NSComparisonResult BTCompareFloats (float a, float b) { return BT_COMPARE_NUMBERS(a, b); }
NSComparisonResult BTCompareDoubles (double a, double b) { return BT_COMPARE_NUMBERS(a, b); }