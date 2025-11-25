import { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "com.alkalam.bookshop",
  appName: "Al Kalam",
  webDir: "dist",
  server: {
    androidScheme: "https",
  },
};

export default config;
