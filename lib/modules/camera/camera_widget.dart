// import 'package:flutter/material.dart';
// import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
// import 'package:pwd_reservation_app/modules/shared/drivers/camera.dart';
// import 'package:camera/camera.dart';

// // ignore: must_be_immutable
// class CameraScreen extends StatelessWidget {
//   CameraScreen({super.key, required this.cameras});
//   final List<CameraDescription> cameras;
//   late CameraDescription firstCamera;

//   await availableCameras().then(
//     (value) => Navigator.push(
//       context, MaterialPageRoute(
//       builder: (_) => CameraPage(cameras: value))
//     ),
//   );
//   @override
//   Widget build (BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(backgroundColor: CustomThemeColors.themeBlue),
//       body: TakePictureScreen(camera: firs),
//     );
//   }
// }