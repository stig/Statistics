//
//  SBStatistics.h
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SBStatistics : NSObject {
    NSUInteger count;
    NSUInteger mindex;
    NSUInteger maxdex;
    
    double min;
    double max;
    double mean;
    double pseudoVariance;
}

// Adds a data point. x must respond to -doubleValue.
- (void)addData:(id)x;

// Adds data points from the given array. Calls -addData: repeatedly.
- (void)addDataFromArray:(NSArray*)x;

// Count of data points
@property(readonly) NSUInteger count;

// Index of smallest and largest data points
@property(readonly) NSUInteger mindex;
@property(readonly) NSUInteger maxdex;

// Value of smallest and largest data points
@property(readonly) double min;
@property(readonly) double max;

// http://en.wikipedia.org/wiki/Arithmetic_mean
@property(readonly) double mean;

// http://en.wikipedia.org/wiki/Range_(statistics)
- (double)range;

// http://en.wikipedia.org/wiki/Variance
- (double)variance;                 // division by N-1
- (double)biasedVariance;           // division by N

// http://en.wikipedia.org/wiki/Standard_deviation
- (double)standardDeviation;        // division by N-1
- (double)biasedStandardDeviation;  // division by N

@end

@interface SBFullStatistics : SBStatistics
{
    NSMutableArray *data;
    NSArray *sortedData;
}

// http://en.wikipedia.org/wiki/Mode_(statistics)
- (double)mode;

// http://en.wikipedia.org/wiki/Median
- (double)median;

// http://en.wikipedia.org/wiki/Harmonic_mean
- (double)harmonicMean;

// http://en.wikipedia.org/wiki/Geometric_mean
- (double)geometricMean;

// http://en.wikipedia.org/wiki/Frequency_distribution
- (NSDictionary*)frequencyDistributionWithBuckets:(NSArray*)x;

// Conveniently create buckets for frequency distribution calculations.
- (NSArray*)bucketsWithCount:(NSUInteger)x;
- (NSArray*)bucketsWithInterval:(double)x;

// Returns the data in the order it was added
- (NSArray*)data;

// Returns the data in sorted order
- (NSArray*)sortedData;

// Returns the data sans low and high outliers
- (NSArray*)sortedDataDiscardingLow:(double)l high:(double)h;

// Return a new statistics object, with outliers removed from the data.
// This can be used to calculate the truncated (trimmed) mean.
// http://en.wikipedia.org/wiki/Truncated_mean
- (id)statisticsDiscardingLow:(double)l high:(double)h;

@end
