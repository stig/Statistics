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

@property(readonly) NSUInteger count;
@property(readonly) NSUInteger mindex;
@property(readonly) NSUInteger maxdex;

@property(readonly) double min;
@property(readonly) double max;
@property(readonly) double mean;

- (double)range;
- (double)variance;
- (double)standardDeviation;
- (double)biasedVariance;
- (double)biasedStandardDeviation;

- (void)addData:(id)x;
- (void)addDataFromArray:(NSArray*)x;

@end
