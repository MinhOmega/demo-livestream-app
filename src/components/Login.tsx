import CustomLogin from '../../specs/LoginNativeComponent';
import React from 'react';
import type {NativeSyntheticEvent} from 'react-native';

interface LoginProps {
  titleText: string;
  userIdPlaceholder: string;
  loginButtonText: string;
  defaultUserId: string;
  userSig: string;
  sdkAppId: number;
  onLoginSuccess: (userId: string) => void;
  onLoginError: (code: string, message: string) => void;
  onLoginSubmit: (userId: string) => void;
}

const Login: React.FC<LoginProps> = ({
  titleText,
  userIdPlaceholder,
  loginButtonText,
  defaultUserId,
  userSig,
  sdkAppId,
  onLoginSuccess,
  onLoginError,
  onLoginSubmit,
}) => {
  const handleLoginSuccess = (event: NativeSyntheticEvent<{userId: string}>) => {
    onLoginSuccess(event.nativeEvent.userId);
  };

  const handleLoginError = (
    event: NativeSyntheticEvent<{code: string; message: string}>,
  ) => {
    onLoginError(event.nativeEvent.code, event.nativeEvent.message);
  };

  const handleLoginSubmit = (event: NativeSyntheticEvent<{userId: string}>) => {
    onLoginSubmit(event.nativeEvent.userId);
  };

  return (
    <CustomLogin
      titleText={titleText}
      userIdPlaceholder={userIdPlaceholder}
      loginButtonText={loginButtonText}
      defaultUserId={defaultUserId}
      userSig={userSig}
      sdkAppId={sdkAppId}
      onLoginSuccess={handleLoginSuccess}
      onLoginError={handleLoginError}
      onLoginSubmit={handleLoginSubmit}
    />
  );
};

export default Login; 