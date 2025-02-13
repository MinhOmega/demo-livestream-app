import React, { useCallback, useState } from 'react';
import { View, StyleSheet, TouchableOpacity, Text, Alert } from 'react-native';
import { LiveStreamView } from '../components/live-stream/LiveStreamView';
import { startLiveStream, stopLiveStream } from '../modules/live-stream';

export const LiveStreamScreen: React.FC = () => {
  const [isStreaming, setIsStreaming] = useState(false);
  const [roomId] = useState(() => Math.floor(Math.random() * 100000));
  const [userId] = useState(`user_${Date.now()}`);

  const handleStartStream = useCallback(async () => {
    try {
      await startLiveStream({ roomId, userId });
      setIsStreaming(true);
    } catch (error) {
      Alert.alert('Error', 'Failed to start live stream');
    }
  }, [roomId, userId]);

  const handleStopStream = useCallback(async () => {
    try {
      await stopLiveStream();
      setIsStreaming(false);
    } catch (error) {
      Alert.alert('Error', 'Failed to stop live stream');
    }
  }, []);

  const handleStatusChange = useCallback((status: string, message?: string) => {
    if (status === 'error') {
      Alert.alert('Stream Error', message || 'An error occurred');
    }
  }, []);

  return (
    <View style={styles.container}>
      <LiveStreamView
        style={styles.preview}
        roomId={isStreaming ? roomId : undefined}
        userId={isStreaming ? userId : undefined}
        onStatusChange={handleStatusChange}
      />
      <View style={styles.controls}>
        <TouchableOpacity
          style={[styles.button, isStreaming && styles.stopButton]}
          onPress={isStreaming ? handleStopStream : handleStartStream}
        >
          <Text style={styles.buttonText}>
            {isStreaming ? 'Stop Stream' : 'Start Stream'}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  preview: {
    flex: 1,
  },
  controls: {
    position: 'absolute',
    bottom: 30,
    left: 0,
    right: 0,
    paddingHorizontal: 20,
  },
  button: {
    backgroundColor: '#007AFF',
    paddingVertical: 12,
    paddingHorizontal: 30,
    borderRadius: 25,
    alignItems: 'center',
  },
  stopButton: {
    backgroundColor: '#FF3B30',
  },
  buttonText: {
    color: '#FFF',
    fontSize: 16,
    fontWeight: '600',
  },
}); 