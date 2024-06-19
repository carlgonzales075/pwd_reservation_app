import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/verify/drivers/verify.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.readOnly,
    this.minLines = 1,
    this.maxLines = 1,
    this.suffixIcon,
    this.onTap
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final int minLines;
  final int maxLines;
  final Widget? suffixIcon;
  final VoidCallback? onTap;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 8
      ),
      child: TextField(
        onTap: widget.onTap,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          labelText: widget.label,
          labelStyle: const TextStyle(
            color: CustomThemeColors.themeBlue,
            fontWeight: FontWeight.bold
          ),
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 16.0
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomThemeColors.themeBlue
            )
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomThemeColors.themeBlue,
              width: 2
            )
          )
        )
      ),
    );
  }
}

class FormButtons extends StatelessWidget {
  const FormButtons({
    super.key,
    required this.disableReject,
    required this.disableApprove,
    required this.showVerify,
    required this.disabilityInfo,
    required this.validatorComments,
    required this.processingId,
    required this.passengerId,
    required this.rfidTag,
    this.verifyFunction
  });

  final bool disableReject;
  final bool disableApprove;
  final bool showVerify;
  final String disabilityInfo;
  final String validatorComments;
  final String processingId;
  final String passengerId;
  final String rfidTag;
  final VoidCallback? verifyFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white
            ),
            onPressed: disableReject ? null : () {
              _postVerification(
                context,
                isApproved: false,
                pwdScInfo: '',
                validatorComments: validatorComments,
                processingId: processingId,
                passengerId: passengerId,
                rfidTag: ''
              );
            },
            child: const Row(
              children: [
                Icon(Icons.cancel_outlined),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('Reject'),
                ),
              ],
            )
          ),
        ),
        Visibility(
          visible: showVerify,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.white
              ),
              onPressed: !showVerify ? null : () {
                if (verifyFunction != null) {
                  verifyFunction!();
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.checklist),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('Verify'),
                  ),
                ],
              )
            ),
          ),
        ),
        Visibility(
          visible: !showVerify,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white
              ),
              onPressed: disableApprove ? null : () {
                _postVerification(
                  context,
                  isApproved: true,
                  pwdScInfo: disabilityInfo,
                  validatorComments: validatorComments,
                  processingId: processingId,
                  passengerId: passengerId,
                  rfidTag: rfidTag
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.check),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('Approve'),
                  ),
                ],
              )
            ),
          ),
        )
      ],
    );
  }

  void _postVerification(BuildContext context, {
      required bool isApproved,
      required String pwdScInfo,
      required String validatorComments,
      required String processingId,
      required String passengerId,
      required String rfidTag
    }) async {
    final bool successful = await DirectusVerification.postVerification(
      context,
      isApproved: isApproved,
      pwdScInfo: pwdScInfo,
      validatorComments: validatorComments,
      processingId: processingId,
      passengerId: passengerId,
      rfidTag: rfidTag
    );
    if (successful) {
      if (context.mounted) {
        if (isApproved) {
          CustomDialogs.customInfoDialog(
            context,
            'Verified!',
            'The passenger is now verified!',
            () {
              Navigator.pop(context);
            }
          );
        } else {
          CustomDialogs.customInfoDialog(
            context,
            'Rejected',
            'The passenger\'s request has been rejected.',
            () {
              Navigator.pop(context);
            }
          );
        }
      }
    }
  }
}

class FormTextLabel extends StatelessWidget {
  const FormTextLabel({
    super.key,
    required this.label
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold
      )
    );
  }
}