/*
Copyright (c) 2008, Stig Brautaset. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  * Neither the name of the author nor the names of its contributors may be
    used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "SBStatistics.h"


/// This class doesn't keep any of the data points, so uses hardly any
/// memory. On the other hand it isn't able to compute the more
/// complex statistics.
/// @see SBFullStatistics
@implementation SBStatistics

@synthesize count;
@synthesize mindex;
@synthesize maxdex;

@synthesize min;
@synthesize max;
@synthesize mean;

#pragma mark Initialisation

- (id)init
{
    self = [super init];
    if (self) {
        min = max = mean = nan(0);
    }
    return self;
}

#pragma mark Adding data

/// @see addData:
- (void)addDataFromArray:(NSArray*)array
{
    for (id x in array)
        [self addData:x];
}

/// Add a datapoint (any NSObject responding  to -doubleValue)
/// @param x must respond to -doubleValue.
- (void)addData:(id)x
{
    NSAssert([x respondsToSelector:@selector(doubleValue)], @"Data must respond to -doubleValue");
	[self addDouble:[x doubleValue]];
}

/// Add a datapoint.
/// This method does most of the work.
/// @param d a double-precision data point to add.
- (void)addDouble:(double)d {
    if (!count) {
        min = INFINITY;
        max = -min;
        mean = 0;
    }
    
    if (d < min) {
        min = d;
        mindex = count;
    }
    if (d > max) {
        max = d;
        maxdex = count;
    }
    
    double oldMean = mean;
    mean += (d - oldMean) / ++count;
    pseudoVariance += (d - mean) * (d - oldMean);
}

#pragma mark Methods

- (double)range
{
    return max - min;
}

/// @see http://en.wikipedia.org/wiki/Variance
- (double)variance
{
    if (count > 1)
        return pseudoVariance / (count - 1);
    return nan(0);
}

/// @see variance
- (double)biasedVariance
{
    if (count > 1)
        return pseudoVariance / count;
    return nan(0);
}

/// @see http://en.wikipedia.org/wiki/Standard_deviation
- (double)standardDeviation
{
    return sqrt([self variance]);
}

/// @see standardDeviation
- (double)biasedStandardDeviation
{
    return sqrt([self biasedVariance]);
}

@end
