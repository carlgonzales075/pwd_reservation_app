import 'package:flutter/material.dart';

import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:provider/provider.dart';

class SelectBusScreen extends StatelessWidget {
  const SelectBusScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bus',
          style: TextStyle(
            color: CustomThemeColors.themeWhite
          )
        ),
        backgroundColor: CustomThemeColors.themeBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<StopsProvider>(builder: (context, stops, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${stops.stopNameDestination}'),
                  const Icon(Icons.chevron_right_sharp),
                  Text('${stops.stopNamePickUp}')
                ],
              ),
            );
          },),
          // FutureBuilder(
          //   future: future,
          //   builder: builder
          // )
        ],
      )
    );
  }
}