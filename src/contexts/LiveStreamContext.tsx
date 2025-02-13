import React, { createContext, useContext, useState, useCallback } from 'react';
import { startLiveStream, stopLiveStream, LiveStreamParams } from '../modules/live-stream';

interface LiveStreamContextType {
  isStreaming: boolean;
  startStream: (params: LiveStreamParams) => Promise<void>;
  stopStream: () => Promise<void>;
}

const LiveStreamContext = createContext<LiveStreamContextType | undefined>(undefined);

export const LiveStreamProvider: React.FC<{children: React.ReactNode}> = ({ children }) => {
  const [isStreaming, setIsStreaming] = useState(false);

  const startStream = useCallback(async (params: LiveStreamParams) => {
    await startLiveStream(params);
    setIsStreaming(true);
  }, []);

  const stopStream = useCallback(async () => {
    await stopLiveStream();
    setIsStreaming(false);
  }, []);

  return (
    <LiveStreamContext.Provider value={{ isStreaming, startStream, stopStream }}>
      {children}
    </LiveStreamContext.Provider>
  );
};

export const useLiveStream = () => {
  const context = useContext(LiveStreamContext);
  if (!context) {
    throw new Error('useLiveStream must be used within a LiveStreamProvider');
  }
  return context;
}; 