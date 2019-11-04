#import "XyoBlePlugin.h"
#import <sdk_xyo_flutter/sdk_xyo_flutter-Swift.h>

@implementation XyoBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftXyoBlePlugin registerWithRegistrar:registrar];
}
@end
