#pragma once

#include <react/renderer/components/view/ViewProps.h>
#include <string>

namespace facebook::react {
  class CustomLoginProps : public ViewProps {
  public:
    CustomLoginProps() = default;
    CustomLoginProps(const CustomLoginProps &sourceProps, const RawProps &rawProps);

    std::string titleText;
    std::string userIdPlaceholder;
    std::string loginButtonText;
    std::string defaultUserId;
    std::string userSig;
    int sdkAppId;
  };
} 