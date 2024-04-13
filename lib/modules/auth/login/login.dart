import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: <Widget>[
        HomePageLogo(),
        LoginCard()
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
      User user = await getUser(accessToken);

      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).updateUser(
          firstName: user.firstName,
          lastName: user.lastName,
          description: user.description,
          avatar: user.avatar,
          email: user.email,
        );
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

  Future<void> _login() async {
    String email = _userNameController.text;
    String password = _passWordController.text;

    try {
      Credentials credentials = await postLogin(email, password);
      
      if (mounted) {
        Provider.of<CredentialsProvider>(context, listen: false).updateCredentials(
          accessToken: credentials.accessToken,
          refreshToken: credentials.refreshToken,
          expires: credentials.expires
        );
        await _getUserInfo(credentials.accessToken);
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
            onPressed: () {},
            child: const Text('Forgot Password?'),
          ),
        ),
        BasicElevatedButton(
          buttonText: 'Login',
          onPressed: () {
            _login();
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