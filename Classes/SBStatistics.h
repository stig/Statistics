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

#import <Foundation/Foundation.h>

/// Sparse statistics class
@interface SBStatistics : NSObject {
    NSUInteger count;
    NSUInteger mindex;
    NSUInteger maxdex;
    
    double min;
    double max;
    double mean;

@private
    double pseudoVariance;
}


/// Add a data point.
- (void)addDouble:(double)d;

/// Add a data point from an object.
- (void)addData:(id)x;

/// Add data points from the given array.
- (void)addDataFromArray:(NSArray*)x;

/// Count of data points
@property(readonly) NSUInteger count;

/// Index of smallest data point
@property(readonly) NSUInteger mindex;

/// Index of largest data point
@property(readonly) NSUInteger maxdex;

/// Value of smallest data point
@property(readonly) double min;

/// Value of largest data point
@property(readonly) double max;

/// The arithmetic mean. @see http://en.wikipedia.org/wiki/Arithmetic_mean
@property(readonly) double mean;

/// Max - min
- (double)range;

/// Variance of sample (division by N-1)
- (double)variance;

/// Variance of population (division by N)
- (double)biasedVariance;

/// Standard deviation of sample (division by N-1)
- (double)standardDeviation;

/// Standard deviation of population (division by N)
- (double)biasedStandardDeviation;

@end

/// Full statistics class.
@interface SBFullStatistics : SBStatistics

/// Most frequently occuring data point
- (double)mode;

/// Middle value in a list of sorted data points
- (double)median;

/// Find the largest data point less than a certain percentage
- (double)percentile:(double)x;

- (double)harmonicMean;

- (double)geometricMean;

/// Returns an (optionally cumulative) frequency distribution.
- (NSDictionary*)frequencyDistributionWithBuckets:(NSArray*)x cumulative:(BOOL)y;

/// Returns x equally-sized buckets covering the range of data.
- (NSArray*)bucketsWithCount:(NSUInteger)x;

/// Returns N buckets of size x covering the range of data.
- (NSArray*)bucketsWithInterval:(double)x;

/// Returns the data in the order it was added.
//- (NSArray*)data;

/// Returns the data in sorted order.
- (NSArray*)sortedData;

/// Returns the data sans low and high outliers.
- (NSArray*)sortedDataDiscardingLowOutliers:(double)l high:(double)h;

/// Returns a new statistics object, with outliers removed from the data.
- (id)statisticsDiscardingLowOutliers:(double)l high:(double)h;

@end
