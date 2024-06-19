import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ApiProfileImage(
      width: 40,
      height: 40,
      scale: true
    );
  }
}