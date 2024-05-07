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
    String domain = context.read<DomainProvider>().url as String;

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
                  '$domain/assets/${userProvider.avatar}?fit=cover&width=40&height=40'
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

class BusImage extends StatefulWidget {
  const BusImage({super.key, required this.assetId});
  final String assetId;
  @override
  State<BusImage> createState() => _BusImage();
}

class _BusImage extends State<BusImage> {
  @override
  Widget build (BuildContext context) {
    String domain = context.read<DomainProvider>().url as String;

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                '$domain/assets/${widget.assetId}'
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: CustomThemeColors.themeGrey,
                offset: Offset(
                  2.0,
                  2.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ), //BoxShadow //BoxShadow
            ],
            borderRadius: const BorderRadius.all(Radius.circular(20.0))
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