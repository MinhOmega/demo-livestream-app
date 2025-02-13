//
//  RCTLiveStream.mm
//  demoLivestreamApp
//
//  Created by Minh Vo on 13/2/25.
//

#import "RCTLiveStream.h"

#import <react/renderer/components/AppSpec/ComponentDescriptors.h>
#import <react/renderer/components/AppSpec/EventEmitters.h>
#import <react/renderer/components/AppSpec/Props.h>
#import <react/renderer/components/AppSpec/RCTComponentViewHelpers.h>
#import <TXLiteAVSDK_TRTC/TRTCCloud.h>

using namespace facebook::react;

@interface RCTLiveStream () <RCTCustomLiveStreamViewProtocol>
@end

@implementation RCTLiveStream {
  TRTCCloud *_trtcCloud;
  UIView *_previewView;
  NSNumber *_roomId;
  NSString *_userId;
}

- (instancetype)init {
  if (self = [super init]) {
    _trtcCloud = [TRTCCloud sharedInstance];
    _previewView = [[UIView alloc] init];
    [self addSubview:_previewView];
    static const auto defaultProps = std::make_shared<const CustomLiveStreamProps>();
    _props = defaultProps;
  }
  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps {
  const auto &oldViewProps = *std::static_pointer_cast<CustomLiveStreamProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<CustomLiveStreamProps const>(props);

  if (oldViewProps.roomId != newViewProps.roomId) {
    _roomId = [NSNumber numberWithInt:newViewProps.roomId];
    if (_roomId) {
      [self startPreview];
    } else {
      [self stopPreview];
    }
  }

  if (oldViewProps.userId != newViewProps.userId) {
    _userId = [NSString stringWithCString:newViewProps.userId.c_str() encoding:NSUTF8StringEncoding];
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _previewView.frame = self.bounds;
}

- (void)startPreview {
  [_trtcCloud startLocalPreview:YES view:_previewView];
  
  CustomLiveStreamEventEmitter::OnStreamStatusChange event = {
    .status = CustomLiveStreamEventEmitter::OnStreamStatusChangeStatus::Connected
  };
  self.eventEmitter.onStreamStatusChange(event);
}

- (void)stopPreview {
  [_trtcCloud stopLocalPreview];
  
  CustomLiveStreamEventEmitter::OnStreamStatusChange event = {
    .status = CustomLiveStreamEventEmitter::OnStreamStatusChangeStatus::Disconnected
  };
  self.eventEmitter.onStreamStatusChange(event);
}

- (const CustomLiveStreamEventEmitter &)eventEmitter {
  return static_cast<const CustomLiveStreamEventEmitter &>(*_eventEmitter);
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<CustomLiveStreamComponentDescriptor>();
}

@end
