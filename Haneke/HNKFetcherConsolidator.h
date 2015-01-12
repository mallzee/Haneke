//
//  HNKFetcherConsolidator.h
//  foursquare-ios-core
//
//  Created by Cameron Mulhern on 1/12/15.
//
//

#import <Foundation/Foundation.h>
#import "HNKCache.h"

@class HNKFetcherWrapper;

/**
 An object that can be used to consolidate multiple fetch requests into a single actual fetch.
 */
@interface HNKFetcherConsolidator : NSObject

@property (nonatomic) BOOL cacheHit;
@property (nonatomic, readonly) BOOL cancelled;

/**
 *  Initializes the consolidator with the given fetcher wrapper.
 *
 *  @param fetcher The fetcher wrapper that will be sent fetchImageWithSuccess:failure:.
 */
- (instancetype)initWithFetcher:(HNKFetcherWrapper *)fetcher;

/**
 *  Adds a fetch request stub to the consolidator.
 *  Any child fetch requests will have their successBlock and failureBlock called when the actual fetch completes.
 *
 *  @param fetcher      Fetcher instance that was provided by the HNKCache consumer.
 *  @param successBlock Block to be called if the fetcher wrapper successfuly provides the original image.
 *  @param failureBlock Block to be called if the fetcher fails to provide the original image.
 */
- (void)addFetchRequestWithFetcher:(id<HNKFetcher>)fetcher successBlock:(void (^)(UIImage *))successBlock failureBlock:(void (^)(NSError *))failureBlock;

/**
 *  Removes a fetch request stub from the consolidator.
 *  If there are no child fetch requests remaining the wrapper's underlying fetcher will be cancelled.
 *
 *  @param fetcher Fetcher instance that was provided by the HNKCache consumer.
 */
- (void)removeFetchRequestWithFetcher:(id<HNKFetcher>)fetcher;

/**
 *  Called on fetch request completion to dispatch the successBlocks of the child fetch requests.
 *
 *  @param image The original image provided by the underlying fetcher.
 */
- (void)dispatchSuccessBlocksWithImage:(UIImage *)image;

/**
 *  Called on fetch failure to dispatch the failureBlocks of the child fetch requests.
 *
 *  @param error The error provided by the underlying fetcher.
 */
- (void)dispatchFailureBlocksWithError:(NSError *)error;

/**
 *  Helper method to generate a unique key that can be used to consolidate fetch requests.
 *
 *  @param fetcher    Fetcher that can provide the original image.
 *  @param formatName Name of the format in which the image is desired.
 *
 *  @return Unique key that represents the fetch request.
 */
+ (NSString *)uniqueKeyForFetcher:(id<HNKFetcher>)fetcher formatName:(NSString *)formatName;

@end
