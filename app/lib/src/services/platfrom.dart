import 'package:flutter/foundation.dart';

class PlatfromService {
  bool get isMobile {
    return !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
  }

  bool get isDesktop {
    return !kIsWeb && (defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux);
  }

  bool get isMacOS {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  }

  bool get isAndroid {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  bool get isWeb => kIsWeb;
}
