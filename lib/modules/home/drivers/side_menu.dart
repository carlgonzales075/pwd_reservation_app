import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/register/drivers/file_upload.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';

void checkPWDApproval(BuildContext context) async {
  int applicationCount = await checkApplicationApproval(
    context.read<DomainProvider>().url as String,
    context.read<CredentialsProvider>().accessToken as String,
    context.read<PassengerProvider>().id as String
  );
  if (applicationCount >= 1 && context.mounted) {
    CustomDialogs.customInfoDialog(
      context,
      'Application Complete',
      'You are already approved as a priority passenger.',
      () {}
    );
  } else {
    if (context.mounted) {
      int progressCount = await checkApplicationProgress(
        context.read<DomainProvider>().url as String,
        context.read<CredentialsProvider>().accessToken as String,
        context.read<PassengerProvider>().id as String
      );
      if (context.mounted) {
        if (progressCount >= 1) {
          CustomDialogs.customInfoDialog(
            context,
            'Application Under Review',
            "You're application is undergoing review. We will get back to you as soon as we can.",
            () {}
          );
        } else {
          Navigator.pushNamed(context, '/register-upload');
        }
      }
    }
  }
}