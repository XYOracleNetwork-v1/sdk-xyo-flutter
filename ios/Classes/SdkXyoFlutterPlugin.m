#import "SdkXyoFlutterPlugin.h"
#import <sdk_xyo_flutter/sdk_xyo_flutter-Swift.h>

@implementation SdkXyoFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSdkXyoFlutterPlugin registerWithRegistrar:registrar];
}
@end
