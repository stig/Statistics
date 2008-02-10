//
//  SBMutableDictionary.h
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary (SBMutableDictionary)

- (void)incrementValueForNumber:(NSNumber*)key;

@end
