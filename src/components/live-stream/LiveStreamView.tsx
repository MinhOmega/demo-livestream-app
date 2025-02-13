import React, {useEffect, useCallback} from 'react';
import {StyleSheet, ViewStyle} from 'react-native';
import LiveStream from '../../../specs/LiveStreamNativeComponent';

interface Props {
  style?: ViewStyle;
  roomId?: number;
  userId?: string;
  onStatusChange?: (
    status: 'connected' | 'disconnected' | 'error',
    message?: string,
  ) => void;
}

export const LiveStreamView: React.FC<Props> = ({
  style,
  roomId = 123,
  userId = '123',
  onStatusChange,
}) => {
  const handleStreamStatusChange = useCallback(
    (event: {
      status: 'connected' | 'disconnected' | 'error';
      message?: string;
    }) => {
      onStatusChange?.(event.status, event.message);
    },
    [onStatusChange],
  );
  console.log('🚀 ~ LiveStreamView.tsx:39 ~ userId:', userId);
  console.log('🚀 ~ LiveStreamView.tsx:39 ~ roomId:', roomId);

  return (
    <LiveStream
      style={[styles.container, style]}
      roomId={roomId}
      userId={userId}
      onStreamStatusChange={handleStreamStatusChange}
    />
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
});
