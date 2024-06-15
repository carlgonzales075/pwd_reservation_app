import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';

class DomainScreen extends StatelessWidget {
  const DomainScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Domain'),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
      ),
      body: const DomainForm()
    );
  }
}

class DomainForm extends StatefulWidget {
  const DomainForm({super.key});

  @override
  State<DomainForm> createState() => _DomainForm();
}

class _DomainForm extends State<DomainForm> {

  @override
  Widget build (BuildContext context) {
    final TextEditingController ipText = TextEditingController(
      text: context.read<DomainProvider>().ipAddress
    );
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: ipText,
              decoration: const InputDecoration(
                hintText: "Enter IP Address for Prototype testing",
                alignLabelWithHint: true,
                labelText: 'IP Address',
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide()
                )
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  context.read<DomainProvider>().updateDomain(ipText.text);
                  if (ipText.text.isNotEmpty) {
                    CustomDialogs.customInfoDialog(
                      context,
                      'Domain Set Successfully!',
                      'http://${ipText.text}:8080 is now used as server url.',
                      () {
                        Navigator.pop(context);
                      }
                    );
                  } else {
                    CustomDialogs.customErrorDialog(
                      context,
                      'No Domain Set',
                      'Please enter a valid IP Address to proceed on testing.'
                    );
                  }
                },
                child: const Text('Confirm')
              ),
            )
          ],
        ),
      ),
    );
  }
}