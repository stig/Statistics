//
//  Statistics.h
//  Statistics
//
//  Created by Stig Brautaset on 09/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class SBStatistics;
@class SBFullStatistics;

@interface Stream : SenTestCase {
    SBStatistics *stat;
}
@end

@interface Full : SenTestCase {
    SBFullStatistics *stat;
}
@end
