//
// Betwixt - Copyright 2012 Three Rings Design

#include "BTInterpolator.h"

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
