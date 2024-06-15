import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/login/widgets/login_fields.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';

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