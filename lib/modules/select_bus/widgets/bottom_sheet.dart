import 'package:flutter/material.dart';

class SelectBusBottomSheet extends StatelessWidget {
  const SelectBusBottomSheet({super.key});

  @override
  Widget build (BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {  }
            ),
            const Text('Select a Bus')
          ]
        )
      ],
    );
  }
}