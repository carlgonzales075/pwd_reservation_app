import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class CameraProvider extends ChangeNotifier {
  List<CameraDescription>? cameras;

  void updateCameras(
    List<CameraDescription>? cameras
  ) {
    this.cameras = cameras;
    notifyListeners();
  }
}

// class PassengerProvider extends ChangeNotifier {
//   String? id;
//   String? passengerType;
//   String? disabilityInfo;
//   String? seatAssigned;
//   bool? isWaiting;
//   bool? isOnRoute;

//   void initPassenger({
//     String? id,
//     String? passengerType,
//     String? disabilityInfo,
//     String? seatAssigned,
//     bool? isWaiting,
//     bool? isOnRoute
//   }) {
//     if (id != null) {
//       this.id = id;
//     }
//     if (passengerType != null) {
//       this.passengerType = passengerType;
//     }
//     if (disabilityInfo != null) {
//       this.disabilityInfo = disabilityInfo;
//     }
//     if (seatAssigned != null) {
//       this.seatAssigned = seatAssigned;
//     }
//     if (isWaiting != null) {
//       this.isWaiting = isWaiting;
//     }
//     if (isOnRoute != null) {
//       this.isOnRoute = isOnRoute;
//     }
//     notifyListeners();
//   }

//   void assignSeat({
//     required String seatAssigned,
//     required bool isWaiting
//   }) {
//     this.seatAssigned = seatAssigned;
//     this.isWaiting = isWaiting;
//     notifyListeners();
//   }

//   void occupySeat({
//     required bool isWaiting,
//     required bool isOnRoute
//   }) {
//     this.isWaiting = isWaiting;
//     this.isOnRoute = isOnRoute;
//     notifyListeners();
//   }

//   void aloftSeat() {
//     seatAssigned = null;
//     isWaiting = null;
//     isOnRoute = null;
//     notifyListeners();
//   }

//   void resetPassenger() {
//     id = null;
//     passengerType = null;
//     disabilityInfo = null;
//     seatAssigned = null;
//     isWaiting = null;
//     isOnRoute = null;
//     notifyListeners();
//   }
// }