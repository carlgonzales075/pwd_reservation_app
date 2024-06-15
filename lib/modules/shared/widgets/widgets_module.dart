import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';

class BasicTextField extends StatefulWidget {
  const BasicTextField({
    super.key,
    required this.textHint,
    this.controller
  });
  final String textHint;
  final TextEditingController? controller;

  @override
  // ignore: library_private_types_in_public_api
  _BasicTextField createState() => _BasicTextField();
}

class _BasicTextField extends State<BasicTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: CustomThemeColors.themeGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: BorderSide.none
            ),
            hintText: widget.textHint,
            contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          ),
        ),
    );
  }
}

class BasicCheckBox extends StatefulWidget {
  const BasicCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.checkboxText,
  });
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final String checkboxText;

  @override
  // ignore: library_private_types_in_public_api
  _BasicCheckBox createState() => _BasicCheckBox();
}

class _BasicCheckBox extends State<BasicCheckBox> {
  @override
  Widget build (BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child:
        CheckboxListTile(
          title: Text(
            widget.checkboxText,
            style: const TextStyle(fontSize: 11),
          ),
          value: widget.value,
          onChanged: widget.onChanged,
        ),
    );
  }
}

class BasicPasswordField extends StatefulWidget {
  const BasicPasswordField({
    super.key,
    required this.textHint,
    this.controller
  });
  final String textHint;
  final TextEditingController? controller;

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<BasicPasswordField> {
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          filled: true,
          fillColor: CustomThemeColors.themeGrey,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: _togglePasswordVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide.none
          ),
          hintText: widget.textHint
        ),
      ),
    );
  }
}

class BasicElevatedButton extends StatelessWidget {
  const BasicElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed
  });

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: CustomThemeColors.themeWhite,
        backgroundColor: CustomThemeColors.themeBlue,
        minimumSize: const Size.fromHeight(50),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Text(buttonText),
    );
  }
}

//Authentication Fields
class PassWordTextField extends StatefulWidget {
  const PassWordTextField({
    super.key,
    required this.controller
  });
  final TextEditingController controller;

  @override
  // ignore: library_private_types_in_public_api
  _PassWordTextField createState() => _PassWordTextField();
}

class _PassWordTextField extends State<PassWordTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: CustomThemeColors.themeGrey,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: CustomThemeColors.themeBlue,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide.none
        ),
        hintText: 'Password',
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      ),
      obscureText: true,
    );
  }
}

class UserNameTextField extends StatefulWidget {
  const UserNameTextField({
    super.key,
    required this.controller
  });
  final TextEditingController controller;
  
  @override
  // ignore: library_private_types_in_public_api
  _UserNameTextField createState() => _UserNameTextField();
}

class _UserNameTextField extends State<UserNameTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: CustomThemeColors.themeGrey,
        prefixIcon: const Icon(
          Icons.person_outline_sharp,
          color: CustomThemeColors.themeBlue,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide.none
        ),
        hintText: 'Email Address',
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      ),
    );
  }
}