import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<DomainProvider>(
          builder: (context, myData, child) {
            if (myData.ipAddress == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const NoDomainAlert();
                  },
                );
              });
            }
            return const HomePageLogo();

          },
        ),
        const LoginCard()
      ],
    );
  }
}

class NoDomainAlert extends StatefulWidget {
  const NoDomainAlert({super.key});

  @override
  State<NoDomainAlert> createState() => _NoDomainAlert();
}

class _NoDomainAlert extends State<NoDomainAlert> {
  @override
  Widget build (BuildContext context) {
    return AlertDialog(
      title: const Text('No Domain Set'),
      content: const Text('Set the domain to start testing.'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/domain');
          },
          child: const Text('OK')
        )
      ],
    );
  }
}

class HomePageLogo extends StatelessWidget {
  const HomePageLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        SizedBox(
          height: 350,
          width: 300,
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Image(
              image: AssetImage('assets/images/pwd.png')
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 200,
            width: 200,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 15, 0),
              child: Text(
                'Priority Passenger App',
                textAlign: TextAlign.right,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: CustomThemeColors.themeWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: const SizedBox(
          height: 400,
          child: Card(
            semanticContainer: false,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: LoginScreenFields(),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreenFields extends StatefulWidget {
  const LoginScreenFields({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenFields createState() => _LoginScreenFields();
}

class _LoginScreenFields extends State<LoginScreenFields> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  late Future<Credentials> credentials;

  Future<void> _getUserInfo(String accessToken) async {
    try {
      if (mounted) {
        User user = await getUser(accessToken, context.read<DomainProvider>().url as String);
        if (mounted) {
          Provider.of<UserProvider>(context, listen: false).updateUser(
            userId: user.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            avatar: user.avatar,
            email: user.email,
          );
          Passengers passenger = await getPassenger(user.userId, accessToken,
          context.read<DomainProvider>().url as String);
          if (mounted) {
            context.read<PassengerProvider>().initPassenger(
              id: passenger.id,
              passengerType: passenger.passengerType,
              disabilityInfo: passenger.disabilityInfo,
              seatAssigned: passenger.seatAssigned,
              isWaiting: passenger.isWaiting,
              isOnRoute: passenger.isOnRoute
            );
          }
          if (mounted) {
            ReservationInfo reservationInfo = await getReservationInfo(
              accessToken, passenger.seatAssigned as String, context.read<DomainProvider>().url as String);
            if (mounted) {
              context.read<ReservationProvider>().initReservation(
                reservationInfo.seatName,
                reservationInfo.routeName,
                reservationInfo.vehicleName,
                reservationInfo.busStopName,
                reservationInfo.distance
              );
            }
          }
        }
      }
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('User Info Request Failed'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      );
    }
  }

  Future<void> _login(String domain) async {
    String email = _userNameController.text;
    String password = _passWordController.text;

    try {
      if (mounted) {
        Credentials credentials = await postLogin(email, password, domain);
        
        if (mounted) {
          Provider.of<CredentialsProvider>(context, listen: false).updateCredentials(
            accessToken: credentials.accessToken,
            refreshToken: credentials.refreshToken,
            expires: credentials.expires
          );
          await _getUserInfo(credentials.accessToken);
        }
      }
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserNameTextField(controller: _userNameController),
        PassWordTextField(controller: _passWordController),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 15,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/domain");
            },
            child: const Text('Forgot Password?'),
          ),
        ),
        BasicElevatedButton(
          buttonText: 'Login',
          onPressed: () {
            _login(context.read<DomainProvider>().url as String);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('Don\'t have an account?'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: CustomThemeColors.themeBlue,
              ),
              child: const Text('Sign Up')
              )
          ],
        )
      ],
    );
  }
}