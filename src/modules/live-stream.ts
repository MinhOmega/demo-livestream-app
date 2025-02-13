import {NativeModules, requireNativeComponent} from 'react-native';

export const LiveStreamManager = NativeModules.LiveStreamManager;
console.log('🚀 ~ live-stream.ts:4 ~ NativeModules:', NativeModules);
export const LiveStreamView = requireNativeComponent('LiveStreamView');

export interface LiveStreamParams {
  roomId: number;
  userId: string;
}

export const startLiveStream = async (
  params: LiveStreamParams,
): Promise<void> => {
  try {
    await LiveStreamManager.startLiveStream(params);
  } catch (error) {
    console.error('Failed to start live stream:', error);
    throw error;
  }
};

export const stopLiveStream = async (): Promise<void> => {
  try {
    await LiveStreamManager.stopLiveStream();
  } catch (error) {
    console.error('Failed to stop live stream:', error);
    throw error;
  }
};
