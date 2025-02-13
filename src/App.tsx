import React from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { Navigation } from './navigation';

const App = () => {
  return (
    <SafeAreaProvider>
      <Navigation />
    </SafeAreaProvider>
  );
};

export default App;

// import React from 'react';
// import {Alert, StyleSheet, View} from 'react-native';
// import WebView from '../specs/WebViewNativeComponent';

// function App(): React.JSX.Element {
//   return (
//     <View style={styles.container}>
//       <WebView
//         sourceURL="https://react.dev/"
//         style={styles.webview}
//         onScriptLoaded={() => {
//           Alert.alert('Page Loaded');
//         }}
//       />
//     </View>
//   );
// }

// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     alignItems: 'center',
//     alignContent: 'center',
//   },
//   webview: {
//     width: '100%',
//     height: '100%',
//   },
// });

// export default App;
