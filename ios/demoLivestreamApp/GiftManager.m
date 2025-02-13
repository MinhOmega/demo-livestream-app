#import "GiftManager.h"
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(GiftManager, NSObject)

RCT_EXTERN_METHOD(showGiftAnimation:(NSString *)giftType 
                  callback:(RCTResponseSenderBlock)callback)

@end 