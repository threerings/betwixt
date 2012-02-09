//
// Betwixt - Copyright 2012 Three Rings Design

#include "BTInterpolator.h"

#define MIN(a,b) (((a)<(b))?(a):(b))

BTInterpolator BTLinearInterpolator = ^ float (float ratio) { return ratio; };
BTInterpolator BTEaseInInterpolator = ^ float (float ratio) { return ratio * ratio * ratio; };
BTInterpolator BTEaseOutInterpolator = ^ float (float ratio) {
    float inverse = ratio - 1.0f;
    return inverse * inverse * inverse + 1.0f;
};
BTInterpolator BTEaseInOutInterpolator = ^ float (float ratio) {
    if (ratio < 0.5f) return 0.5f * BTEaseOutInterpolator(ratio * 2.0f);
    else  return 0.5f * BTEaseInInterpolator((ratio - 0.5f) * 2.0f) + 0.5f;
};

float BTInterpolate (float from, float to, float elapsedTime, float totalTime, 
                     BTInterpolator interp) {
    elapsedTime = MIN(elapsedTime, totalTime);
    return from + ((to - from) * interp(elapsedTime / totalTime));
}
