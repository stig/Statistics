//
//  Statistics.m
//  Statistics
//
//  Created by Stig Brautaset on 09/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "Tests.h"
#import <Statistics/Statistics.h>


@implementation Tests

- (void)testMin {
    values = [@"1 2 -2" componentsSeparatedByString:@" "];
    STAssertEqualsWithAccuracy([values min], -2.0, 1e-3, nil);
}

- (void)testMax {
    values = [@"1 2 -2" componentsSeparatedByString:@" "];
    STAssertEqualsWithAccuracy([values max], 2.0, 1e-3, nil);
}

- (void)testMean {
    values = [@"1 2 2" componentsSeparatedByString:@" "];
    STAssertEqualsWithAccuracy([values mean], 1.6666, 1e-3, nil);

    values = [@"1 2 2 -5" componentsSeparatedByString:@" "];
    STAssertEqualsWithAccuracy([values mean], 0.0, 1e-3, nil);
}

- (void)testMedian {
    values = [@"9 3.3 1 2 2" componentsSeparatedByString:@" "];
    STAssertEqualsWithAccuracy([values median], 2.0, 1e-6, nil);

    values = [@"9 4 3.3 1 2 2" componentsSeparatedByString:@" "];
    STAssertEqualsWithAccuracy([values median], (3.3 + 2)/2, 1e-6, nil);

    values = [@"9 4 -3.3 1 2 2" componentsSeparatedByString:@" "];
    STAssertEqualsWithAccuracy([values median], 2.0, 1e-6, nil);
}


@end
