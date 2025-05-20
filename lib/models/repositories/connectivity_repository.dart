import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityRepository {
  final Connectivity _connectivity = Connectivity();

  Future<bool> get hasInternet async {
    try {
      final response = await http
          .get(
            Uri.parse('https://www.google.com/generate_204'),
          )
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  Stream<bool> get connectivityChanges async* {
    await for (final _ in _connectivity.onConnectivityChanged) {
      yield await hasInternet;
    }
  }
}
