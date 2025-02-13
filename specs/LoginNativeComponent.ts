import type { HostComponent, ViewProps } from 'react-native';
import type { DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import { Int32 } from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

type LoginSubmitEvent = {
  userId: string;
};

type LoginSuccessEvent = {
  userId: string;
  name?: string;
  avatar?: string;
};

type LoginErrorEvent = {
  code: string;
  message: string;
};

export interface NativeProps extends ViewProps {
  // Props
  titleText?: string;
  userIdPlaceholder?: string;
  loginButtonText?: string;
  defaultUserId?: string;
  userSig?: string;
  sdkAppId?: Int32;

  // Events
  onLoginSubmit?: DirectEventHandler<LoginSubmitEvent>;
  onLoginSuccess?: DirectEventHandler<LoginSuccessEvent>;
  onLoginError?: DirectEventHandler<LoginErrorEvent>;
}

export default codegenNativeComponent<NativeProps>(
  'CustomLogin',
) as HostComponent<NativeProps>;
