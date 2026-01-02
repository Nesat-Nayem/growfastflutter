import 'dart:async';

import 'package:flutter/widgets.dart';

class BlocRefreshStream extends ChangeNotifier {
  BlocRefreshStream(Stream stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }
  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
