import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class RegisterAuthScreen extends StatefulWidget {
  const RegisterAuthScreen({super.key});

  @override
  State<RegisterAuthScreen> createState() => _RegisterAuthScreen();
}

class _RegisterAuthScreen extends State<RegisterAuthScreen> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String buttonText = 'Create Account';
  bool isChecked = false;

  Future<void> _registerHelperFunc(bool isChecked) async {
    final firstName = _firstName.text;
    final lastName = _lastName.text;
    final email = _email.text;
    final password = _password.text;
    final confirmPassword = _confirmPassword.text;

    bool confirmRequiredFilled = (
      firstName != ''
      && lastName != ''
      && email != ''
      && password != ''
      && confirmPassword != ''
    );
    bool confirmPasswordMatch = (password == confirmPassword);

    if (confirmRequiredFilled && confirmPasswordMatch) {
      DirectusUser directusUser = DirectusUser(context);
      await directusUser.createUser(firstName, lastName, email, password);
    } else {
      CustomDialogs.customErrorDialog(
        context,
        'Form Invalid',
        'The form submitted either has an empty field or the password did not match.'
      );
    }
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomThemeColors.themeBlue,
        elevation: 0,
        title: const Text(
                'Personal Info',
                style: TextStyle(
                  color: CustomThemeColors.themeWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
        )
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 100,
                  child: Icon(
                    Icons.person_add_alt_outlined,
                    size: 80,
                    color: CustomThemeColors.themeBlue,
                  ),
                ),
                BasicTextField(
                  textHint: 'First Name',
                  controller: _firstName,
                ),
                BasicTextField(
                  textHint: 'Last Name',
                  controller: _lastName,
                ),
                BasicTextField(
                  textHint: 'Email',
                  controller: _email,
                ),
                BasicPasswordField(
                  textHint: 'Enter Password',
                  controller: _password,
                ),
                BasicPasswordField(
                  textHint: 'Confirm Password',
                  controller: _confirmPassword,
                ),
                const SizedBox(height: 20.0),
                BasicElevatedButton(
                  buttonText: buttonText,
                  onPressed: () => _registerHelperFunc(isChecked),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}