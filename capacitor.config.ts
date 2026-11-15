import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'app.trimplay',
  appName: 'TrimPlay',
  webDir: 'dist',
  // TanStack Start needs its hosted server; never bundle the Worker in iOS.
  server: { url: 'https://trimplay.app/?app=ios', cleartext: false },
  ios: { contentInset: 'automatic' },
};

export default config;