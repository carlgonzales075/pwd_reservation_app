import 'package:flutter/material.dart';
// import 'package:pwd_reservation_app/modules/home/footer_menu/footer_menu.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build (BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            HomeScreenHeader(),
            HomeScreenBody(),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: FooterMenu(),
      // ),
    );
  }
}

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CustomThemeColors.themeBlue,
        borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(10))
      ),
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.menu,
                    color: CustomThemeColors.themeWhite,
                  )
                ),
                const LogOutButton()
              ],
            ),
            const HomeScreenNameCard()
          ],
        ),
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CredentialsProvider>(
      builder: (context, credentials, child) {
      return IconButton(
      onPressed: () {
        logOut(credentials.refreshToken);
        credentials.resetValues();
        context.read<StopsProvider>().resetValues();
        Navigator.pushNamed(context, '/');
      },
      icon: const Icon(
        Icons.logout,
        color: CustomThemeColors.themeWhite,
      )
    );},
        );
  }
}

class HomeScreenNameCard extends StatelessWidget {
  const HomeScreenNameCard({super.key});

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
                      userProvider.description ?? 'No Disability',
                      style: const TextStyle(color: CustomThemeColors.themeWhite)
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

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ApiProfileImage();
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build (BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 15.0),
                const Text(
                  'My PWD Card',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomThemeColors.themeBlue
                  ),
                ),
                const SizedBox(height: 8.0),
                const Card(
                  color: CustomThemeColors.themeBlue,
                  child: HomeScreenNameCard(),
                ),
                const SizedBox(height: 14.0),
                const Text(
                  'Next Transit',
                  style: TextStyle(
                    color: CustomThemeColors.themeBlue,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 8.0),
                const Card(
                  color: CustomThemeColors.themeLightBlue,
                  child: SizedBox(
                    height: 130,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'EDSA Carousel',
                              style: TextStyle(
                                color: CustomThemeColors.themeWhite,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Taft Avenue',
                              style: TextStyle(
                                color: CustomThemeColors.themeWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 20.0),
                BasicElevatedButton(
                  buttonText: 'Book Reservation',
                  onPressed: () {
                    Navigator.pushNamed(context, '/reservation');
                  }
                )
              ],
            )
          ),
        );
      }
    );
  }
}