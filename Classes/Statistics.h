//
//  Statistics.h
//  Statistics
//
//  Created by Stig Brautaset on 09/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Statistics)

- (double)min;
- (double)max;
- (double)mean;
- (double)median;
- (double)mindex;
- (double)maxdex;
- (double)variance;
- (double)standardDeviation;

@end
