//
//  NSObject+BlockObservation.h
//  https://gist.github.com/153676 @ 4eecf9d6dd54cc44f4932b97352554717a5c3547
//
//  Andy Matuschak
//  andy@andymatuschak.org
//  Public domain because I love you. Let me know how you use it.
//

typedef NSString AMBlockToken;
typedef void (^AMBlockTask)(id obj, NSDictionary *change);

#define OBSERVE_SELF(PATH, CODE) \
[self addObserverForKeyPath:(PATH) task:^(id obj, NSDictionary *change) { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-retain-cycles\"") \
do { CODE; } while(0); \
_Pragma("clang diagnostic pop") \
}];


@interface NSObject (AMBlockObservation)
- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath task:(AMBlockTask)task;
- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(AMBlockTask)task;
- (void)removeObserverWithBlockToken:(AMBlockToken *)token;
@end
