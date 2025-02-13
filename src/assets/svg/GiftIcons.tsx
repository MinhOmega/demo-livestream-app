import React from 'react';
import Svg, { Path, Circle, G } from 'react-native-svg';

export const HeartGift = ({ width = 60, height = 60, color = '#FF4B4B' }) => (
  <Svg width={width} height={height} viewBox="0 0 24 24">
    <Path
      d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"
      fill={color}
    />
  </Svg>
);

export const StarGift = ({ width = 60, height = 60, color = '#FFD700' }) => (
  <Svg width={width} height={height} viewBox="0 0 24 24">
    <Path
      d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"
      fill={color}
    />
  </Svg>
);

export const DiamondGift = ({ width = 60, height = 60, color = '#00BCD4' }) => (
  <Svg width={width} height={height} viewBox="0 0 24 24">
    <Path
      d="M12 2L2 8l10 6 10-6-10-6zM2 15l10 6 10-6-10-6-10 6z"
      fill={color}
    />
  </Svg>
); 