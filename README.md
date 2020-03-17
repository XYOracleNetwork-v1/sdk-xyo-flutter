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

A robust Flutter solution for mobile, cross-platform integration. This SDK was written from ground-up, in Flutter, to give developers another tool in integrating XYO in their mobile solution.

Not only will this SDK make XYO apps better, but bring XYO functionality to existing apps.  This SDK follows the updated paradigm of ble client/server thinking in bound witness operations.

## Install

Add this to your pubspec:

```yaml
dependencies: 
  sdk_xyo_flutter: ^0.2.2
```

Update your packages:

```bash
flutter pub get
```

If you are using VSCode, you will be prompted to update packages in the editor.

## Usage

Look at the [example](example/lib/main.dart), for implementation of the SDK in a created state complete with widgets. 

Bringing the node into your widgets can be as simple as 

```dart
  XyoNode _xyoNode;
```

From there you can utilize the SDK Methods

```dart
  _xyoNode.getClient('ble')
```

Once you get the client or server, you can use the public key and bound witness data however you like. We have found the **Flexible Widget** to be helpful in working with dynamic datasets. 

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

Again, for implementation examples, see the [example app here](example/lib/main.dart)

> We are working on a full getting started guide.

## License

See the [LICENSE](LICENSE) file for license details.

## Credits

Made with 🔥and ❄️ by [XYO](https://www.xyo.network)

