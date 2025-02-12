#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(LiveStreamBridge, NSObject)

RCT_EXTERN_METHOD(joinLiveStream:(NSString *)roomId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end 