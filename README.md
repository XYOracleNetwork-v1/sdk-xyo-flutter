[logo]: https://cdn.xy.company/img/brand/XYO_full_colored.png

[![logo]](https://xyo.network)

![](https://github.com/XYOracleNetwork/sdk-xyo-flutter/workflows/iOS%20Build/badge.svg?branch=develop)
![](https://github.com/XYOracleNetwork/sdk-xyo-flutter/workflows/APK%20Build/badge.svg?branch=develop)
[![BCH compliance](https://bettercodehub.com/edge/badge/XYOracleNetwork/sdk-xyo-flutter?branch=master)](https://bettercodehub.com/) [![Known Vulnerabilities](https://snyk.io/test/github/XYOracleNetwork/sdk-xyo-flutter/badge.svg?targetFile=android/build.gradle)](https://snyk.io/test/github/XYOracleNetwork/sdk-xyo-flutter?targetFile=android/build.gradle)



# XYO Flutter SDK

## Table of Contents

-   [Title](#xyo-flutter-sdk)
-   [Description](#description)
-   [Install](#install)
-   [Usage](#usage)
-   [License](#license)
-   [Credits](#credits)

## Description

A robust Bluetooth solution for Android. This BLE SDK was written from ground-up, in Kotlin, to help developers with the agonizing issues with Android the BLE stack.
Not only will this SDK make XYO apps better, but bring XYO functionality to existing apps.  In addition to generalized BLE support, the SDK also has specific support for XY spacific hardware.

## Install

Add this to your pubspec:

```yaml
dependencies: 
  sdk_xyo_flutter: ^0.1.0
```

Update your packages:

```bash
flutter pub get
```

If you are using VSCode, you will be prompted to update packages in the editor.

## Usage

### Enums

`XyoNodeType`

  - `client`
  - `server`

`XyoScannerStatus`

  - `none`
  - `enabled`
  - `bluetoothDisabled`
  - `bluetoothUnavailable`
  - `locationDisabled`
  - `unknown`

### Methods

`getClient`

`getServer`

`addListener`

`setListening`

`getPublicKey`

`onDeviceDetected`

`onBoundWitnessSuccess`

For implementation examples, see the [example app here](example/lib/main.dart)

> We are working on a full getting started guide.

## License

See the [LICENSE](LICENSE) file for license details.

## Credits

Made with 🔥and ❄️ by [XYO](https://www.xyo.network)

