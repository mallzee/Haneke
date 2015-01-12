//
//  HNKFetcherWrapper.m
//  foursquare-ios-core
//
//  Created by Cameron Mulhern on 1/12/15.
//
//

#import "HNKFetcherWrapper.h"

@implementation HNKFetcherWrapper {
    id<HNKFetcher> _fetcher;
}

- (instancetype)initWithFetcher:(id<HNKFetcher>)fetcher
{
    if (self = [super init])
    {
        _fetcher = fetcher;
    }
    return self;
}

- (NSString *)key
{
    return _fetcher.key;
}

- (void)fetchImageWithSuccess:(void (^)(UIImage *))successBlock failure:(void (^)(NSError *))failureBlock
{
    [_fetcher fetchImageWithSuccess:successBlock failure:failureBlock];
}

- (void)cancelFetch
{
    if ([_fetcher respondsToSelector:@selector(cancelFetch)])
    {
        [_fetcher cancelFetch];
    }
}

@end
