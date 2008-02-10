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

@end
