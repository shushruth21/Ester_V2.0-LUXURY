import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.estre.app',
  appName: 'estre',
  webDir: 'dist',
  server: {
    url: 'https://5b3c3a43-2162-42b6-9d0f-eab048dc728a.lovableproject.com?forceHideBadge=true',
    cleartext: true
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      launchAutoHide: true,
      backgroundColor: "#1a1a1a",
      androidSplashResourceName: "splash",
      showSpinner: false,
      splashFullScreen: true,
      splashImmersive: true
    }
  },
  bundledWebRuntime: false
};

export default config;