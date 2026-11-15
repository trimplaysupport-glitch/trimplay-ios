# Welcome to your Lovable project

This project was built with [Lovable](https://lovable.dev).

## Build with Lovable

Open your project in the [Lovable editor](https://lovable.dev) and keep building.

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: connect the project to GitHub and every change made in Lovable is committed straight to your repository.
- **Full ownership**: this code is yours. Push to your repository and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```

## Built with

- TanStack Start
- TypeScript
- React
- Tailwind CSS

## Native iOS (Capacitor + Codemagic)

- Identity: `TrimPlay`, bundle ID `app.trimplay`, Capacitor `webDir: dist`.
- Install dependencies with `bun install --frozen-lockfile` (the repository uses `bun.lock`). Node 22+ is required.
- Run `npm run build:ios` on macOS to build the web assets, stage browser-only output into `dist`, and sync the tracked `ios/` project. Open it with `npx cap open ios`.
- The staging command is necessary: the normal TanStack build produces `dist/client` plus a server bundle, not a standalone `dist/index.html`. Do not ship the server bundle. `build:ios` replaces `dist` with browser assets; run `npm run build` again before a web deployment.
- The native app loads `https://trimplay.app/?app=ios` over HTTPS. It requires the published site and internet access; this is not a standalone/offline conversion. Existing iPhone-mode purchase restrictions remain in effect.
- Capacitor 8 uses Swift Package Manager: `ios/App/App.xcodeproj` and `ios/App/CapApp-SPM/Package.swift` replace the need for a CocoaPods `Podfile`. Xcode 26+ is required.

### Codemagic setup

1. Connect this GitHub repository to Codemagic and select the `ios-release` workflow in `codemagic.yaml`.
2. Register `app.trimplay` in your Apple Developer account and create the matching App Store Connect app. Apple Developer membership is required.
3. Add an App Store Connect API integration named `trimplay-app-store` in Codemagic. Upload or generate the matching App Store distribution certificate and provisioning profile there; keep Apple private keys out of this repository.
4. Start a build. The workflow syncs Capacitor, resolves Swift packages, applies signing, produces an IPA, and uploads to TestFlight. App Store review submission is manual.
5. Before submission, replace the generated placeholder iOS icon with your approved icon, complete privacy/store metadata, and test real video import/playback on an iPhone. A web wrapper is not a guarantee of App Store approval.

The root `.gitignore` does not ignore `ios/` and is platform-managed. Repository commits/sync are managed by Lovable's connected GitHub integration; local Git commits are not performed by this setup. Signing, an actual Xcode archive, GitHub sync, and TestFlight delivery must be confirmed in your connected services.
