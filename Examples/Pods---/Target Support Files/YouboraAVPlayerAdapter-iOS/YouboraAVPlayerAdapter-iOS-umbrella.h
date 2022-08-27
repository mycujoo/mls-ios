#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "YBAVPlayerAdapter.h"
#import "YBAVPlayerAdapterSwiftWrapper.h"
#import "YBAVPlayerAdsAdapter.h"
#import "YBAVPlayerAdsAdapterSwiftWrapper.h"
#import "YBAVPlayerP2PAdapter.h"
#import "YBAVPlayerPolynetAdapter.h"
#import "YBAVPlayerStreamrootAdapter.h"
#import "YBAVPlayerAdapterTranformer.h"
#import "YouboraAVPlayerAdapter.h"

FOUNDATION_EXPORT double YouboraAVPlayerAdapterVersionNumber;
FOUNDATION_EXPORT const unsigned char YouboraAVPlayerAdapterVersionString[];

