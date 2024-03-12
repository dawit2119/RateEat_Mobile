import 'package:connectivity_plus/connectivity_plus.dart';

import 'network.dart';

class NetworkHelper {
  static void observeNetwork() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        NetworkBloc().add(const NetworkNotify());
      } else {
        NetworkBloc().add(const NetworkNotify(isConnected: true));
      }
    });
  }
}
