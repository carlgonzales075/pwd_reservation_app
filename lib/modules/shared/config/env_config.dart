import 'package:flutter/material.dart';

// class DomainEnvs {
//   static const String _devEnvDomain = 'http://192.168.176.1:8080';
//   static const String _prodEnvDomain = 'http://sample.com';
//   static const bool isDev = true;

//   static String getDomain() {
//     if (isDev) {
//       return _devEnvDomain;
//     } else {
//       return _prodEnvDomain;
//     }
//   }
// }

class DomainProvider extends ChangeNotifier {
    String? url;
    String? ipAddress;

    void updateDomain(
      String? ipAddress
    ) {
      this.ipAddress = ipAddress;
      url = "http://$ipAddress:8080";
      notifyListeners();
    }

    void resetDomain() {
      ipAddress = null;
      url = null;
      notifyListeners();
    }
}