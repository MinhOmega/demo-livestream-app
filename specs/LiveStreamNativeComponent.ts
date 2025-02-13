import type {HostComponent, ViewProps} from 'react-native';
import type {BubblingEventHandler, Int32} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

type LiveStreamEvent = {
  status: 'connected' | 'disconnected' | 'error';
  message?: string;
};

export interface NativeProps extends ViewProps {
  roomId?: Int32;
  userId?: string;
  onStreamStatusChange?: BubblingEventHandler<LiveStreamEvent> | null;
}

export default codegenNativeComponent<NativeProps>(
  'CustomLiveStream',
) as HostComponent<NativeProps>;