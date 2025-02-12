import React, { useCallback } from 'react';
import {
  View,
  TouchableOpacity,
  Text,
  StyleSheet,
  Alert,
  NativeModules,
} from 'react-native';

const { LiveStreamBridge } = NativeModules;

const LiveStreamScreen: React.FC = () => {
  const handleJoinLiveStream = useCallback(async (roomId: string) => {
    try {
      const result = await LiveStreamBridge.joinLiveStream(roomId);
      if (!result.success) {
        Alert.alert('Error', 'Failed to join live stream');
      }
    } catch (error) {
      console.error('Join live stream error:', error);
      Alert.alert('Error', 'Failed to join live stream');
    }
  }, []);

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={styles.button}
        onPress={() => handleJoinLiveStream('test_room_1')}>
        <Text style={styles.buttonText}>Join Live Stream</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  button: {
    backgroundColor: '#1C66E5',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 8,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
});

export default LiveStreamScreen; 