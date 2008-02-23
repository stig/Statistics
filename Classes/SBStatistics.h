//
//  SBStatistics.h
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

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
@interface SBFullStatistics : SBStatistics {
    NSMutableArray *data;
    NSArray *sortedData;
}

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
- (NSArray*)data;

/// Returns the data in sorted order.
- (NSArray*)sortedData;

/// Returns the data sans low and high outliers.
- (NSArray*)sortedDataDiscardingLowOutliers:(double)l high:(double)h;

/// Returns a new statistics object, with outliers removed from the data.
- (id)statisticsDiscardingLowOutliers:(double)l high:(double)h;

@end
