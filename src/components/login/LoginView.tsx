import React, {useCallback} from 'react';
import {StyleSheet, ViewStyle} from 'react-native';
import Login from '../../../specs/LoginNativeComponent';

interface Props {
  style?: ViewStyle;
  placeholder?: string;
  onSubmit?: (username: string, password: string) => void;
  onError?: (code: string, message: string) => void;
}

export const LoginView: React.FC<Props> = ({
  style,
  placeholder,
  onSubmit,
  onError,
}) => {
  const handleLoginSubmit = useCallback(
    (event: {nativeEvent: {username: string; password: string}}) => {
      onSubmit?.(event.nativeEvent.username, event.nativeEvent.password);
    },
    [onSubmit],
  );

  const handleLoginError = useCallback(
    (event: {code: string; message: string}) => {
      onError?.(event.code, event.message);
    },
    [onError],
  );

  return (
    <Login
      style={[styles.container, style]}
      placeholder={placeholder}
      onLoginSubmit={handleLoginSubmit}
      onLoginError={handleLoginError}
    />
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFF',
  },
}); 