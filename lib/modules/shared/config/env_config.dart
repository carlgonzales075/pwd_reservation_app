import 'package:flutter/material.dart';

class DomainProvider extends ChangeNotifier {
    String? url;
    String? ipAddress;

    DomainProvider({String ipAddress = '192.168.137.1'}) {
      updateDomain(ipAddress);
    }

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