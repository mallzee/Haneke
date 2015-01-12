//
//  HNKFetcherWrapper.h
//  foursquare-ios-core
//
//  Created by Cameron Mulhern on 1/12/15.
//
//

#import <Foundation/Foundation.h>
#import "Haneke.h"

/**
 A wrapper of an HNKFetcher instance that is used as the actual fetcher for fetch requests.
 */
@interface HNKFetcherWrapper : NSObject <HNKFetcher>

- (instancetype)initWithFetcher:(id<HNKFetcher>)fetcher;

- (void)cancelFetch;

@end
