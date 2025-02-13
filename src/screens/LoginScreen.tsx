import React from 'react';
import {StyleSheet, View} from 'react-native';
import Login from '../components/Login';
import getLatestUserSig from '../debug';
import {SDKAPPID} from '../debug/config';

const LoginScreen = () => {
  const userId = '123456';
  const userSig = getLatestUserSig(userId).userSig;
  return (
    <View style={styles.container}>
      <Login
        titleText="Login"
        userIdPlaceholder="Enter your user ID"
        loginButtonText="Login"
        defaultUserId="123456"
        userSig={userSig}
        sdkAppId={SDKAPPID}
        onLoginSuccess={() => {}}
        onLoginError={() => {}}
        onLoginSubmit={() => {}}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default LoginScreen;
