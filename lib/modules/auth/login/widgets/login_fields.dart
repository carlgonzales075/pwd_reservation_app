import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/buttons.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';

class LoginScreenFields extends StatefulWidget {
  const LoginScreenFields({
    super.key,
  });

  @override
  State<LoginScreenFields> createState() => _LoginScreenFields();
}

class _LoginScreenFields extends State<LoginScreenFields> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  late Future<Credentials> credentials;

  Future<void> _login() async {
    String email = _userNameController.text;
    String password = _passWordController.text;

    FocusScope.of(context).nextFocus();
    late String userType;
    if (mounted) {
      DirectusAuth directusAuth = DirectusAuth(context);
      userType = await directusAuth.logInToCredentials(email, password);
    }
    if (mounted) {
      if (userType == 'Passenger') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/employee-home');
      }
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
        APIElevatedButton(
          onPressed: () => _login(),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomThemeColors.themeBlue,
            foregroundColor: CustomThemeColors.themeWhite,
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Login'),
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