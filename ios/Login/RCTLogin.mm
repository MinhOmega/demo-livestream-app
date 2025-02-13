//
//  RCTLogin.mm
//  demoLivestreamApp
//
//  Created by Minh Vo on 13/2/25.
//

#import "RCTLogin.h"
#import <react/renderer/components/AppSpec/ComponentDescriptors.h>
#import <react/renderer/components/AppSpec/EventEmitters.h>
#import <react/renderer/components/AppSpec/Props.h>
#import <react/renderer/components/AppSpec/RCTComponentViewHelpers.h>
#import <TUICore/TUILogin.h>

using namespace facebook::react;

@interface RCTLogin () <RCTCustomLoginViewProtocol, UITextFieldDelegate>
@end

@implementation RCTLogin {
    UIView *_logoContentView;
    UIImageView *_tencentCloudImage;
    UILabel *_titleLabel;
    UIView *_userIdContentView;
    UILabel *_userIdTextLabel;
    UITextField *_userIdTextField;
    UIButton *_loginBtn;
    UIActivityIndicatorView *_loading;
}

- (instancetype)init {
    if (self = [super init]) {
        static const auto defaultProps = std::make_shared<const CustomLoginProps>();
        _props = defaultProps;
        
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupViews {
    // Logo Content View
    _logoContentView = [[UIView alloc] init];
    _logoContentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_logoContentView];
    
    // Tencent Cloud Image
    _tencentCloudImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tencent_cloud"]];
    [_logoContentView addSubview:_tencentCloudImage];
    
    // Title Label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:32];
    _titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [_logoContentView addSubview:_titleLabel];
    
    // UserId Content View
    _userIdContentView = [[UIView alloc] init];
    _userIdContentView.backgroundColor = UIColor.whiteColor;
    _userIdContentView.layer.cornerRadius = 10;
    _userIdContentView.layer.masksToBounds = YES;
    _userIdContentView.layer.borderWidth = 1;
    _userIdContentView.layer.borderColor = UIColor.grayColor.CGColor;
    [self addSubview:_userIdContentView];
    
    // UserId Text Label
    _userIdTextLabel = [[UILabel alloc] init];
    _userIdTextLabel.font = [UIFont systemFontOfSize:20];
    _userIdTextLabel.textColor = UIColor.blackColor;
    _userIdTextLabel.text = @"UserId";
    [_userIdContentView addSubview:_userIdTextLabel];
    
    // UserId TextField
    _userIdTextField = [[UITextField alloc] init];
    _userIdTextField.backgroundColor = UIColor.whiteColor;
    _userIdTextField.font = [UIFont systemFontOfSize:20];
    _userIdTextField.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    _userIdTextField.delegate = self;
    [_userIdContentView addSubview:_userIdTextField];
    
    // Login Button
    _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    _loginBtn.backgroundColor = [UIColor colorWithRed:0 green:0.431 blue:1 alpha:1.0];
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn addTarget:self action:@selector(handleLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginBtn];
    
    // Loading Indicator
    _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    [self addSubview:_loading];
}

- (void)setupConstraints {
    // Setup your constraints here using frame-based layout or other constraint systems
    // This is a simplified version - you might want to add proper constraints
    _logoContentView.frame = CGRectMake(20, 100, self.bounds.size.width - 40, 100);
    _userIdContentView.frame = CGRectMake(20, self.bounds.size.height/2, self.bounds.size.width - 40, 60);
    _loginBtn.frame = CGRectMake(20, CGRectGetMaxY(_userIdContentView.frame) + 40, self.bounds.size.width - 40, 52);
    _loading.center = self.center;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps {
    const auto &oldViewProps = *std::static_pointer_cast<CustomLoginProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<CustomLoginProps const>(props);
    
    // Update title text
    if (oldViewProps.titleText != newViewProps.titleText) {
        _titleLabel.text = [NSString stringWithUTF8String:newViewProps.titleText.c_str()];
    }
    
    // Update placeholder
    if (oldViewProps.userIdPlaceholder != newViewProps.userIdPlaceholder) {
        _userIdTextField.placeholder = [NSString stringWithUTF8String:newViewProps.userIdPlaceholder.c_str()];
    }
    
    // Update login button text
    if (oldViewProps.loginButtonText != newViewProps.loginButtonText) {
        [_loginBtn setTitle:[NSString stringWithUTF8String:newViewProps.loginButtonText.c_str()] forState:UIControlStateNormal];
    }
    
    // Update default userId
    if (oldViewProps.defaultUserId != newViewProps.defaultUserId) {
        _userIdTextField.text = [NSString stringWithUTF8String:newViewProps.defaultUserId.c_str()];
    }
    
    // Update userSig
    if (oldViewProps.userSig != newViewProps.userSig) {
        self.userSig = [NSString stringWithUTF8String:newViewProps.userSig.c_str()];
    }
    
    // Update sdkAppId
    if (oldViewProps.sdkAppId != newViewProps.sdkAppId) {
        self.sdkAppId = newViewProps.sdkAppId;
    }
    
    [super updateProps:props oldProps:oldProps];
}

- (void)handleLogin {
    if (_userIdTextField.text.length == 0) {
        CustomLoginEventEmitter::OnLoginError error = {
            .code = std::to_string(-1),
            .message = "UserId cannot be empty"
        };
        self.eventEmitter.onLoginError(error);
        return;
    }
    
    if (self.userSig.length == 0) {
        CustomLoginEventEmitter::OnLoginError error = {
            .code = std::to_string(-1),
            .message = "UserSig cannot be empty"
        };
        self.eventEmitter.onLoginError(error);
        return;
    }
    
    [_loading startAnimating];
    
    // Emit login submit event
    CustomLoginEventEmitter::OnLoginSubmit submit = {
        .userId = std::string([_userIdTextField.text UTF8String])
    };
    self.eventEmitter.onLoginSubmit(submit);
    
    // Get userId from text field
    NSString *userId = _userIdTextField.text;
    
    // Login with provided userSig and sdkAppId
    [TUILogin login:self.sdkAppId
             userID:userId
            userSig:self.userSig
             succ:^{
        [self->_loading stopAnimating];
        
        CustomLoginEventEmitter::OnLoginSuccess success = {
            .userId = std::string([userId UTF8String])
        };
        self.eventEmitter.onLoginSuccess(success);
        
    } fail:^(int code, NSString * _Nonnull msg) {
        [self->_loading stopAnimating];
        
        CustomLoginEventEmitter::OnLoginError error = {
            .code = std::to_string(code),
            .message = std::string([msg UTF8String])
        };
        self.eventEmitter.onLoginError(error);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    
    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:string];
    return [allowedCharacters isSupersetOfSet:characterSet];
}

- (const CustomLoginEventEmitter &)eventEmitter {
    return static_cast<const CustomLoginEventEmitter &>(*_eventEmitter);
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
    return concreteComponentDescriptorProvider<CustomLoginComponentDescriptor>();
}

@end
