import 'package:flutter/material.dart';

class FooterMenu extends StatelessWidget {
  const FooterMenu({super.key});

  @override
  Widget build (BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: const Text('This is a footer'),
    );
  }
}