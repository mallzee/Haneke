//
//  HNKFetcherConsolidator.m
//  foursquare-ios-core
//
//  Created by Cameron Mulhern on 1/12/15.
//
//

#import "HNKFetcherConsolidator.h"
#import "HNKFetcherWrapper.h"

@interface HNKFetchRequest : NSObject

@property (nonatomic) id<HNKFetcher> fetcher;
@property (nonatomic, copy) void (^successBlock)(UIImage *);
@property (nonatomic, copy) void (^failureBlock)(NSError *);
@end

@implementation HNKFetchRequest

- (instancetype)initWithFetcher:(id<HNKFetcher>)fetcher successBlock:(void (^)(UIImage *))successBlock failureBlock:(void (^)(NSError *))failureBlock
{
    if (self = [super init])
    {
        self.fetcher = fetcher;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
    }
    return self;
}

@end

@implementation HNKFetcherConsolidator {
    HNKFetcherWrapper *_primaryFetcher;
    NSMutableArray *_childFetchRequests;
}

- (instancetype)initWithFetcher:(HNKFetcherWrapper *)fetcher
{
    if (self = [super init])
    {
        _primaryFetcher = fetcher;
        _childFetchRequests = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addFetchRequestWithFetcher:(id<HNKFetcher>)fetcher successBlock:(void (^)(UIImage *))successBlock failureBlock:(void (^)(NSError *))failureBlock
{
    HNKFetchRequest *fetchRequest = [[HNKFetchRequest alloc] initWithFetcher:fetcher successBlock:successBlock failureBlock:failureBlock];
    [_childFetchRequests addObject:fetchRequest];
}

- (void)removeFetchRequestWithFetcher:(id<HNKFetcher>)fetcher
{
    NSUInteger index = [_childFetchRequests indexOfObjectPassingTest:^BOOL(HNKFetchRequest *fetchRequest, NSUInteger idx, BOOL *stop) {
        return fetchRequest.fetcher == fetcher;
    }];
    
    if (index != NSNotFound)
    {
        [_childFetchRequests removeObjectAtIndex:index];
        
        if (_childFetchRequests.count == 0)
        {
            [_primaryFetcher cancelFetch];
            _cancelled = YES;
        }
    }
}

- (void)dispatchSuccessBlocksWithImage:(UIImage *)image
{
    for (HNKFetchRequest *fetchRequest in _childFetchRequests)
    {
        if (fetchRequest.successBlock)
        {
            fetchRequest.successBlock(image);
        }
    }
}

- (void)dispatchFailureBlocksWithError:(NSError *)error
{
    for (HNKFetchRequest *fetchRequest in _childFetchRequests)
    {
        if (fetchRequest.failureBlock)
        {
            fetchRequest.failureBlock(error);
        }
    }
}

+ (NSString *)uniqueKeyForFetcher:(id<HNKFetcher>)fetcher formatName:(NSString *)formatName
{
    return [NSString stringWithFormat:@"%@-%@-%@", NSStringFromClass([fetcher class]), fetcher.key, formatName];
}

@end
