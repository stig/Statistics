//
//  Statistics.h
//  Statistics
//
//  Created by Stig Brautaset on 09/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import <XCTest/XCTest.h>

@class SBStatistics;
@class SBFullStatistics;

@interface Stream : XCTestCase {
    SBStatistics *stat;
}
@end

@interface Full : XCTestCase {
    SBFullStatistics *stat;
}
@end

@interface Errors : XCTestCase {
    SBFullStatistics *stat;
}
@end

