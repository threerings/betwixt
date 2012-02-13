//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTUtils.h"

id BTNSNullToNil (id obj) { return (obj == [NSNull null] ? nil : obj); }

id BTNilToNSNull (id obj) { return (obj == nil ? [NSNull null] : obj); }
