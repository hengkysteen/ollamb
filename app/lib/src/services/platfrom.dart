import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show BuildContext, MediaQuery;

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

  bool isMobileSize(BuildContext context) {
    return isWeb && MediaQuery.of(context).size.width < 500;
  }
}
