[![Build Status](https://travis-ci.org/stig/Statistics.png?branch=master)](https://travis-ci.org/stig/Statistics)

# Statistics

Statistics is a Foundation framework for calculating&mdash;no points
for guessing it&mdash;statistics. It is inspired by Perl's <a
href="http://search.cpan.org/dist/Statistics-Descriptive/">
Statistics::Descriptive</a> and like it consists of two main classes.

SBStatistics calculates a range of statistical measurements on the fly
as each data point is added. The data is then immediately discarded,
giving it a very low memory footprint.

SBFullStatistics in turn subclasses SBStatistics and records each data
point. It is therefore able to provide more advanced statistical
functions. The trade-off is that it can consume a lot of memory if you
are collecting a lot of data.

## Examples

The following example assumes you have included the @p
Statistics/Statistics.h header and somehow linked to the Statistics
framework:

    // Create statistics object
    SBStatistics *stat = [SBStatistics new];
    
    // Add some random data points
    for (int i = 0; i < 1000; i++)
        [stat addData:[NSNumber numberWithInt:random()/1000.0]];

    // Format report
    id fmt = [NSMutableArray array];
    [fmt addObject:@"Data set consists of %u data points."];
    [fmt addObject:@" * Min:      %f"];
    [fmt addObject:@" * Max:      %f"];
    [fmt addObject:@" * Mean:     %f"];
    [fmt addObject:@" * Variance: %f"];
    [fmt addObject:@" * StdDev:   %f"];
    
    // Print it
    NSLog([fmt componentsJoinedByString:@"\n"],
        stat.count,
        stat.min,
        stat.max,
        stat.mean,
        [stat variance],
        [stat standardDeviation]
    );

The SBFullStatistics class can do other interesting stuff:

    // Create statistics object
    SBFullStatistics *stat = [SBFullStatistics new];
    
    // Add some random data.
    for (int i = 0; i < 1e4; i++)
        [stat addData:[NSNumber numberWithDouble:random()]];
    
    // Produce 10 equally-sized buckets covering the entire range
    id buckets = [stat bucketsWithCount:10];
    
    // Calculate frequency distributions.
    id freq = [stat frequencyDistributionWithBuckets:buckets
                                          cumulative:NO];
    id cfreq = [stat frequencyDistributionWithBuckets:buckets
                                           cumulative:YES];
    
    // Iterate over the buckets and output the values
    for (id bucket in buckets)
        NSLog(@"%@ => %@ => %@",
            bucket,
            [freq objectForKey:bucket],
            [cfreq objectForKey:bucket]);


## Download

* [Master branch](http://github.com/stig/Statistics/zipball/master)

## License

Copyright (c) 2008-2013, Stig Brautaset. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,   this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Author

* [Stig Brautaset](stig@brautaset.org)

