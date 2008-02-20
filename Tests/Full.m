//
//  Full.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "Tests.h"
#import <Statistics/Statistics.h>

#define keyval(k, v) [NSNumber numberWithDouble:v], [NSNumber numberWithDouble:k]


@implementation Full

#pragma mark Setup / Teardown

- (void)setUp {
    stat = [SBFullStatistics new];
}

- (void)tearDown {
    [stat release];
}


#pragma mark Tests

- (void)testMode {
    [stat addDataFromArray:[@"9 3.3 1 2 2" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat mode], 2.0, 1e-6, nil);
    
    [stat addDataFromArray:[@"4 4 4" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat mode], 4.0, 1e-6, nil);

    // Ensure string/number agnosticism
    [stat addData:[NSNumber numberWithInt:2]];
    [stat addData:[NSNumber numberWithInt:2]];
    STAssertEqualsWithAccuracy([stat mode], 2.0, 1e-6, nil);
}

- (void)testMedian {
     [stat addDataFromArray:[@"9 3.3 1 2 2" componentsSeparatedByString:@" "]];
     STAssertEqualsWithAccuracy([stat median], 2.0, 1e-6, nil);
 
     [stat addData:@"4"];
     STAssertEqualsWithAccuracy([stat median], (3.3 + 2)/2, 1e-6, nil);
 
     [stat addData:@"-4"];
     [stat addData:@"-4"];
     STAssertEqualsWithAccuracy([stat median], 2.0, 1e-6, nil);
 }

- (void)testFrequencyDistribution {
    [stat addDataFromArray:[@"9 3.3 1 5 2" componentsSeparatedByString:@" "]];
    id expect = [NSDictionary dictionaryWithObjectsAndKeys:
                 keyval(9, 1),
                 keyval(5, 4),
                 nil];
    STAssertEqualObjects([stat frequencyDistributionWithPartitions:2], expect, nil);

    id expect2 = [NSDictionary dictionaryWithObjectsAndKeys:
                  keyval(9, 1),
                  keyval(7, 0),
                  keyval(5, 2),
                  keyval(3, 2),
                  nil];
    STAssertEqualObjects([stat frequencyDistributionWithPartitions:4], expect2, nil);
    
    // Now add a negative number.
    [stat addDataFromArray:[@"-9" componentsSeparatedByString:@" "]];
    id expect3 = [NSDictionary dictionaryWithObjectsAndKeys:
                  keyval(9, 2),
                  keyval(4.5, 3),
                  keyval(0, 0),
                  keyval(-4.5, 1),
                  nil];
    STAssertEqualObjects([stat frequencyDistributionWithPartitions:4], expect3, nil);
}

- (void)testFrequencyDistributionWithBuckets {
    [stat addDataFromArray:[@"9 3.3 1 5 2" componentsSeparatedByString:@" "]];
    id expect = [NSDictionary dictionaryWithObjectsAndKeys:
                 keyval(10, 3),
                 keyval(3.2, 2),
                 nil];

    id buckets = [@"10 3.2" componentsSeparatedByString:@" "];
    STAssertEqualObjects([stat frequencyDistributionWithBuckets:buckets], expect, nil);    
}

- (void)testFrequencyDistributionPerformance {
    int n = 1e5;
    int i;
    for (i = 0; i < n; i++)
        [stat addData:[NSNumber numberWithInt:random()]];
    
    id start = [NSDate date];
    [stat frequencyDistributionWithPartitions:n/100];
    STAssertTrue(-[start timeIntervalSinceNow] < 3.0, @"Should be quick");
}

- (void)testTrimmedMean {
    [stat addDataFromArray:[@"4 108 4 4 4 4 4 4 0 4" componentsSeparatedByString:@" "]];
    STAssertEquals(stat.count, (NSUInteger)10, nil);
    STAssertEqualsWithAccuracy([stat trimmedMeanByDiscarding:0.1], 4.0, 1e-6, nil);
    STAssertEqualsWithAccuracy([stat trimmedMeanByDiscarding:0.05], 14.0, 1e-6, nil);
}

- (void)testTrimmedMeanHighLow {
    [stat addDataFromArray:[@"0 15 15 15 35" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat trimmedMeanByDiscardingLow:0.0 high:0.2], 10.0, 1e-6, nil);
    STAssertEqualsWithAccuracy([stat trimmedMeanByDiscardingLow:0.2 high:0.0], 20.0, 1e-6, nil);
    STAssertEqualsWithAccuracy([stat trimmedMeanByDiscardingLow:0.2 high:0.2], 15.0, 1e-6, nil);
}

- (void)testHarmonicMean {
    [stat addDataFromArray:[@"8 9 10" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat harmonicMean], 8.926, 1e-3, nil);
}

- (void)testGeometricMean {
    [stat addDataFromArray:[@"1 0.5 0.25" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat geometricMean], 0.5, 1e-6, nil);
}

@end
