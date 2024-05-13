import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';

class RegisterAuthScreen extends StatefulWidget {
  const RegisterAuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterAuthScreen createState() => _RegisterAuthScreen();
}

class _RegisterAuthScreen extends State<RegisterAuthScreen> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String buttonText = 'Create Account';
  bool isChecked = false;

  Future<void> _getUserInfo(String accessToken, String domain) async {
    try {
      if (mounted) {
        User user = await getUser(accessToken, domain);

        if (mounted) {
          Provider.of<UserProvider>(context, listen: false).updateUser(
            userId: user.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            avatar: user.avatar,
            email: user.email,
          );
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

  Future<void> _registerHelperFunc(bool isChecked) async {
    final firstName = _firstName.text;
    final lastName = _lastName.text;
    final email = _email.text;
    final password = _password.text;
    final confirmPassword = _confirmPassword.text;
    if (
      _confirmForm(
        password,
        confirmPassword,
        firstName,
        lastName,
        email
      )
    ) {
      // print('Email $email');
      // print('Password $password');
      try {
        await _register(context.read<DomainProvider>().url as String);
      } catch (e) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registration Failed'),
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
        try {
          if (mounted) {
            Credentials credentials = await postLogin(email, password,
              context.read<DomainProvider>().url as String
            );
            
            if (mounted) {
              Provider.of<CredentialsProvider>(context, listen: false).updateCredentials(
                accessToken: credentials.accessToken,
                refreshToken: credentials.refreshToken,
                expires: credentials.expires
              );
              await _getUserInfo(credentials.accessToken,
                context.read<DomainProvider>().url as String
              );
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
    } else {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Form Invalid'),
            content: const Text('The form submitted either has an empty field or the password did not match.'),
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

  Future<void> _register(String domain) async {
    final firstName = _firstName.text;
    final lastName = _lastName.text;
    final email = _email.text;
    final password = _password.text;
    try {
      await postCreateUser(
        firstName,
        lastName,
        email,
        password,
        domain
      );
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Failed.'),
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

  bool _confirmForm(
    String? password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
    String? email
  ) {
    bool confirmRequiredFilled = (
      firstName != ''
      && lastName != ''
      && email != ''
      && password != ''
      && confirmPassword != ''
    );
    bool confirmPasswordMatch = (password == confirmPassword);
    return confirmRequiredFilled && confirmPasswordMatch;
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
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                // BasicCheckBox(
                //   value: isChecked,
                //   checkboxText: 'Are you a PWD/SC/Pregnant Passenger?',
                //   onChanged: (bool? value) {
                //     setState(() {
                //       isChecked = value!;
                //       buttonText = 'Create Account';
                //     });
                //   },
                // ),
                BasicElevatedButton(
                  buttonText: buttonText,
                  onPressed: () {_registerHelperFunc(isChecked);},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}