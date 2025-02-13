//
//  RCTLogin.h
//  demoLivestreamApp
//
//  Created by Minh Vo on 13/2/25.
//

#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>
#import <react/renderer/components/AppSpec/Props.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTLogin : RCTViewComponentView

@property (nonatomic, copy) NSString *userSig;
@property (nonatomic, assign) NSInteger sdkAppId;
@property (nonatomic, strong) NSString *userId;

@end

NS_ASSUME_NONNULL_END
