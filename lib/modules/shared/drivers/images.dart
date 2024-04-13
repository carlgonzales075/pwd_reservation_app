import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as image;

class ApiProfileImage extends StatefulWidget {
  const ApiProfileImage({
    super.key
  });

  @override
  // ignore: library_private_types_in_public_api
  _ApiProfileImage createState() => _ApiProfileImage();
}

class _ApiProfileImage extends State<ApiProfileImage> {
  @override
  Widget build (BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return CircleAvatar(
          radius: 30,
          backgroundColor: CustomThemeColors.themeGrey,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: userProvider.avatar != null ? NetworkImage(
                  '${DomainEnvs.getDomain()}/assets/${userProvider.avatar}?fit=cover&width=40&height=40'
                ) : const AssetImage('assets/images/profileIcon100.jpg') as ImageProvider,
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
        );
      }
    );
  }
}

// class OtherImage extends StatefulWidget {
//   const OtherImage({
//     super.key
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _OtherImage createState() => _OtherImage();
// }

// class _OtherImage extends State<OtherImage> {
//   @override
//   Widget build (BuildContext context) {
//     return Consumer<UserProvider>(
//       builder: (context, userProvider, child) {
//         return CircleAvatar(
//           radius: 30,
//           backgroundColor: CustomThemeColors.themeGrey,
//           child: Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: userProvider.avatar != null ? NetworkImage(
//                   '${DomainEnvs.getDomain()}/assets/${userProvider.avatar}?fit=cover&width=40&height=40'
//                 ) : const AssetImage('assets/images/profileIcon100.jpg') as ImageProvider,
//                 fit: BoxFit.cover,
//               ),
//               shape: BoxShape.circle,
//             ),
//           ),
//         );
//       }
//     );
//   }
// }