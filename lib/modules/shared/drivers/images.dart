import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
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

class ApiPartnerImage extends StatefulWidget {
  const ApiPartnerImage({
    super.key
  });

  @override
  State<ApiPartnerImage> createState() => _ApiPartnerImage();
}

class _ApiPartnerImage extends State<ApiPartnerImage> {
  @override
  Widget build (BuildContext context) {
    String domain = context.read<DomainProvider>().url as String;

    return Consumer<PartnerEmployeeProvider>(
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

class BusImageProfile extends StatefulWidget {
  const BusImageProfile({super.key, required this.assetId});
  final String assetId;
  @override
  State<BusImageProfile> createState() => _BusImageProfile();
}

class _BusImageProfile extends State<BusImageProfile> {
  @override
  Widget build(BuildContext context) {
    String domain = context.read<DomainProvider>().url as String;

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(5.0),  // Add padding of 10 pixels on all sides
          child: Container(
            width: 90,  // Set width to 100 pixels
            height: 90,  // Set height to 100 pixels
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  '$domain/assets/${widget.assetId}',
                ),
                fit: BoxFit.cover,  // Ensures the image covers the entire container
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        );
      },
    );
  }
}
