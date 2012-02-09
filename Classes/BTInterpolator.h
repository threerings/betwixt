//
// Betwixt - Copyright 2012 Three Rings Design

typedef float (^BTInterpolator)(float);

BTInterpolator BTLinearInterpolator;
BTInterpolator BTEaseInInterpolator;
BTInterpolator BTEaseOutInterpolator;
BTInterpolator BTEaseInOutInterpolator;

float BTInterpolate (float from, float to, float elapsedTime, float totalTime, 
                     BTInterpolator interp);
