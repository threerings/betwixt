//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRandoms.h"

/* 
 A C-program for MT19937, with initialization improved 2002/1/26.
 Coded by Takuji Nishimura and Makoto Matsumoto.
 
 Before using, initialize the state by using init_genrand(seed)  
 or init_by_array(init_key, key_length).
 
 Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
 All rights reserved.                          
 Copyright (C) 2005, Mutsuo Saito,
 All rights reserved.                          
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 3. The names of its contributors may not be used to endorse or promote 
 products derived from this software without specific prior written 
 permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 
 Any feedback is very welcome.
 http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html
 email: m-mat @ math.sci.hiroshima-u.ac.jp (remove space)
 */

#include <stdio.h>

/* Period parameters */  
#define N 624
#define M 397
#define MATRIX_A 0x9908b0dfUL   /* constant vector a */
#define UPPER_MASK 0x80000000UL /* most significant w-r bits */
#define LOWER_MASK 0x7fffffffUL /* least significant r bits */

@interface BTRandoms () {
    unsigned long mt[N]; /* the array for the state vector  */
    int mti;//=N+1; /* mti==N+1 means mt[N] is not initialized */
}
- (void)init_genrand:(unsigned long)s;
- (unsigned long)genrand_int32;
- (long)genrand_int31;
- (double)genrand_real1;
- (double)genrand_real2;
- (double)genrand_real3;
- (double)gendrand_res53;
@end

@implementation BTRandoms

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    mti = N+1;
    [self setSeed:(unsigned int)time(0)];
    return self;
}

- (id)initWithSeed:(unsigned int)seed {
    if (!(self = [super init])) {
        return nil;
    }
    mti = N+1;
    [self setSeed:seed];
    return self;
}

- (void)setSeed:(unsigned int)seed {
    [self init_genrand:seed];
}

- (int)getInt:(int)high {
    return (int) ([self genrand_int32] % (unsigned long) high);
}

- (int)getIntLow:(int)low high:(int)high {
    return low + [self getInt:high - low];
}

- (float)getFloat:(float)high {
    return [self genrand_real2] * high;
}

- (float)getFloatLow:(float)low high:(float)high {
    return low + ([self genrand_real2] * (high - low));
}

- (BOOL)getBool {
    return [self genrand_int32] % 2 != 0;
}

- (BOOL)getChance:(int)n {
    return (0 == [self getInt:n]);
}

- (BOOL)getProbability:(float)p {
    return [self getFloat:1] < p;
}

- (id)getObject:(NSArray*)array {
    return (array.count > 0 ? [array objectAtIndex:[self getInt:array.count]] : nil);
}

- (int)getDiceRoll:(int)numDice d:(int)numFaces {
    int sum = 0;
    for (int ii = 0; ii < numDice; ++ii) {
        sum += [self getIntLow:1 high:numFaces + 1];
    }
    return sum;
}

/* initializes mt[N] with a seed */
- (void)init_genrand:(unsigned long)s {
    mt[0]= s & 0xffffffffUL;
    for (mti=1; mti<N; mti++) {
        mt[mti] = 
	    (1812433253UL * (mt[mti-1] ^ (mt[mti-1] >> 30)) + mti); 
        /* See Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier. */
        /* In the previous versions, MSBs of the seed affect   */
        /* only MSBs of the array mt[].                        */
        /* 2002/01/09 modified by Makoto Matsumoto             */
        mt[mti] &= 0xffffffffUL;
        /* for >32 bit machines */
    }
}

/* generates a random number on [0,0xffffffff]-interval */
- (unsigned long)genrand_int32 {
    unsigned long y;
    static unsigned long mag01[2]={0x0UL, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */
    
    if (mti >= N) { /* generate N words at one time */
        int kk;
        
        if (mti == N+1)   /* if init_genrand() has not been called, */
            [self init_genrand:5489UL]; /* a default initial seed is used */
        
        for (kk=0;kk<N-M;kk++) {
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1UL];
        }
        for (;kk<N-1;kk++) {
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1UL];
        }
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1UL];
        
        mti = 0;
    }
    
    y = mt[mti++];
    
    /* Tempering */
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);
    
    return y;
}

/* generates a random number on [0,0x7fffffff]-interval */
- (long)genrand_int31 {
    return (long)([self genrand_int32]>>1);
}

/* generates a random number on [0,1]-real-interval */
- (double)genrand_real1 {
    return [self genrand_int32]*(1.0/4294967295.0); 
    /* divided by 2^32-1 */ 
}

/* generates a random number on [0,1)-real-interval */
- (double)genrand_real2 {
    return [self genrand_int32]*(1.0/4294967296.0); 
    /* divided by 2^32 */
}

/* generates a random number on (0,1)-real-interval */
- (double)genrand_real3 {
    return (((double)[self genrand_int32]) + 0.5)*(1.0/4294967296.0); 
    /* divided by 2^32 */
}

/* generates a random number on [0,1) with 53-bit resolution*/
- (double)gendrand_res53 {
    unsigned long a=[self genrand_int32]>>5, b=[self genrand_int32]>>6; 
    return(a*67108864.0+b)*(1.0/9007199254740992.0); 
} 
/* These real versions are due to Isaku Wada, 2002/01/09 added */

@end

