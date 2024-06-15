import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class ApiProfileImage extends StatefulWidget {
  const ApiProfileImage({
    super.key,
    required this.width,
    required this.height,
    required this.scale
  });

  final double width;
  final double height;
  final bool scale;

  @override
  // ignore: library_private_types_in_public_api
  _ApiProfileImage createState() => _ApiProfileImage();
}

class _ApiProfileImage extends State<ApiProfileImage> {
  @override
  Widget build (BuildContext context) {
    String domain = context.read<DomainProvider>().url as String;
    String assetImage = widget.scale ? 'assets/images/profileIcon100.jpg': 'assets/images/profileIcon.jpg';
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return CircleAvatar(
          radius: 30,
          backgroundColor: CustomThemeColors.themeGrey,
          child: Container(
            width: widget.width * 60/40,
            height: widget.height * 60/40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: userProvider.avatar != null ? NetworkImage(
                  '$domain/assets/${userProvider.avatar}?fit=cover&width=${widget.width}&height=${widget.height}&quality=50'
                ) : AssetImage(assetImage) as ImageProvider,
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

class EditProfileImage extends StatefulWidget {
  const EditProfileImage({
    super.key,
    required this.width,
    required this.height,
    required this.scale
  });

  final double width;
  final double height;
  final bool scale;

  @override
  // ignore: library_private_types_in_public_api
  State<EditProfileImage> createState() => _EditProfileImage();
}

class _EditProfileImage extends State<EditProfileImage> {
  @override
  Widget build (BuildContext context) {
    String domain = context.read<DomainProvider>().url as String;
    String assetImage = widget.scale ? 'assets/images/profileIcon100.jpg': 'assets/images/profileIcon.jpg';
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return CircleAvatar(
          radius: 30,
          backgroundColor: CustomThemeColors.themeGrey,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: userProvider.avatar != null ? NetworkImage(
                  '$domain/assets/${userProvider.avatar}?fit=cover&width=${widget.width}&height=${widget.height}'
                ) : AssetImage(assetImage) as ImageProvider,
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

class PassengerImage extends StatefulWidget {
  const PassengerImage({
    super.key,
    required this.width,
    required this.height,
    required this.scale,
    required this.imageUrl
  });

  final double width;
  final double height;
  final bool scale;
  final String? imageUrl;

  @override
  // ignore: library_private_types_in_public_api
  State<PassengerImage> createState() => _PassengerImage();
}

class _PassengerImage extends State<PassengerImage> {
  @override
  Widget build (BuildContext context) {
    String domain = context.read<DomainProvider>().url as String;
    // String assetImage = widget.scale ? 'assets/images/profileIcon100.jpg': 'assets/images/profileIcon.jpg';
    String assetImage = 'assets/images/profileIcon100.jpg';
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return CircleAvatar(
          radius: 30,
          backgroundColor: CustomThemeColors.themeGrey,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: AssetImage(assetImage) as ImageProvider,
                image: widget.imageUrl != null ? NetworkImage(
                  '$domain/assets/${widget.imageUrl}?fit=cover&width=${widget.width}&height=${widget.height}'
                ) : AssetImage(assetImage) as ImageProvider,
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
            width: 100,  // Set width to 100 pixels
            height: 130,  // Set height to 100 pixels
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
