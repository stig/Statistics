//
//  Full.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "Tests.h"
#import <Statistics/Statistics.h>


@implementation Full

#pragma mark Setup / Teardown

- (void)setUp {
    stat = [SBFullStatistics new];
}

- (void)tearDown {
    [stat release];
}


#pragma mark Tests


 - (void)testMedian {
     [stat addDataFromArray:[@"9 3.3 1 2 2" componentsSeparatedByString:@" "]];
     STAssertEqualsWithAccuracy([stat median], 2.0, 1e-6, nil);
 
     [stat addData:@"4"];
     STAssertEqualsWithAccuracy([stat median], (3.3 + 2)/2, 1e-6, nil);
 
     [stat addData:@"-4"];
     [stat addData:@"-4"];
     STAssertEqualsWithAccuracy([stat median], 2.0, 1e-6, nil);
 }

@end
