import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/home/home_screen.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class EmployeeHomeScreenHeader extends StatelessWidget {
  const EmployeeHomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: CustomThemeColors.themeBlue,
        borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(10))
      ),
      child: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            EmployeeHomeScreenNameCard()
          ],
        ),
      ),
    );
  }
}

class EmployeeHomeScreenNameCard extends StatelessWidget {
  const EmployeeHomeScreenNameCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const ProfilePicture(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: CustomThemeColors.themeWhite
                      ),
                    ),
                    Text(
                      '${userProvider.firstName} ${userProvider.lastName}',
                      style: const TextStyle(
                        color: CustomThemeColors.themeWhite,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      '${userProvider.role}',
                      style: const TextStyle(
                        color: CustomThemeColors.themeWhite
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}