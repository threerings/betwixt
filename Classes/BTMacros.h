//
// Betwixt - Copyright 2012 Three Rings Design

#define BT_VARARGS_TO_ARRAY(type, first) ({ \
    va_list ap; \
    va_start(ap, child); \
    NSMutableArray* children = [[NSMutableArray alloc] init]; \
    for (; child != nil; child = va_arg(ap, type)) [children addObject:child]; \
    va_end(ap); \
    children; \
    })