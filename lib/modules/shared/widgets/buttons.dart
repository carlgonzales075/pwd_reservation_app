import 'package:flutter/material.dart';

class APIElevatedButton extends StatefulWidget {
  const APIElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;

  @override
  State<APIElevatedButton> createState() => _APIElevatedButtonState();
}

class _APIElevatedButtonState extends State<APIElevatedButton> {
  @override
  Widget build (BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.onPressed,
      child: widget.child
    );
  }
}