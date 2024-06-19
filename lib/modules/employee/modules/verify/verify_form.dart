import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/verify/drivers/verify.dart';
import 'package:pwd_reservation_app/modules/employee/modules/verify/widgets/verify_formfields.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';

class VerifyForm extends StatefulWidget {
  const VerifyForm({
    super.key,
    required this.fullName,
    required this.frontId,
    required this.backId,
    required this.selfie,
    required this.processingId,
    required this.passengerId,
    this.disabilityInfo,
    this.rfidNo,

  });

  final String passengerId;
  final String processingId;
  final String fullName;
  final String frontId;
  final String backId;
  final String selfie;
  final String? disabilityInfo;
  final String? rfidNo;

  @override
  State<VerifyForm> createState() => _VerifyFormState();
}

class _VerifyFormState extends State<VerifyForm> {
  final TextEditingController _validatorComments = TextEditingController();
  final TextEditingController _priorityInfo = TextEditingController();
  final TextEditingController _rfidNo = TextEditingController();

  bool disableApprove = true;
  bool? isUnique;

  @override
  void initState() {
    super.initState();

    _priorityInfo.text = widget.disabilityInfo ?? '';
    _rfidNo.text = widget.rfidNo ?? '';

    _priorityInfo.addListener(_updateButtonState);
    _validatorComments.addListener(_updateButtonState);
    _rfidNo.addListener(_updateButtonState);

    _updateButtonState();
  }

  void _updateButtonState() {
    setState(() {
      disableApprove = _priorityInfo.text.isEmpty || _validatorComments.text.isEmpty || _rfidNo.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _validatorComments.dispose();
    _priorityInfo.dispose();
    _rfidNo.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fullName),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const FormTextLabel(label: 'Front of ID'),
              IdNetworkImage(assetId: widget.frontId),
              const FormTextLabel(label: 'Back of ID'),
              IdNetworkImage(assetId: widget.backId),
              const FormTextLabel(label: 'Selfie with ID'),
              IdNetworkImage(assetId: widget.selfie),
              FormTextField(
                label: 'PWD/SC Info',
                controller: _priorityInfo,
                readOnly: widget.disabilityInfo != null,
              ),
              FormTextField(
                label: 'RFID Number',
                controller: _rfidNo,
                readOnly: widget.rfidNo != null,
                suffixIcon: IconButton(
                  onPressed: isUnique != null ? null : () async {
                    await _checkRfidMethod(context);
                  },
                  icon: Icon(
                    isUnique == null ? Icons.search : Icons.check_circle,
                    color: isUnique == null ? Colors.black : Colors.green,
                  )
                ),
              ),
              FormTextField(
                label: 'Validator Comments',
                controller: _validatorComments,
                readOnly: false,
                minLines: 3,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        FormButtons(
          disableReject: widget.disabilityInfo != null,
          disableApprove: disableApprove,
          showVerify: isUnique == null,
          verifyFunction: () async => await _checkRfidMethod(context),
          disabilityInfo: _priorityInfo.text,
          validatorComments: _validatorComments.text,
          passengerId: widget.passengerId,
          processingId: widget.processingId,
          rfidTag: _rfidNo.text,
        )
      ],
    );
  }

  Future<void> _checkRfidMethod(BuildContext context) async {
    if (_rfidNo.text != '') {
      final bool newIsUnique = await DirectusVerification.checkRfidUniqueness(
        context, rfidTag: _rfidNo.text,
        passengerId: widget.passengerId
      );
      setState(() {
        isUnique = newIsUnique;
      });
      if (context.mounted) {
        if (newIsUnique) {
          CustomDialogs.customInfoDialog(
            context, 
            'RFID Unique', 
            'The RFID Tag used is verified as unique for ${widget.fullName}.', 
            () {}
          );
        } else {
          CustomDialogs.customErrorDialog(
            context,
            'Duplicate RFID',
            'The RFID Tag is already assigned to someone else. Please use another card.'
          );
        }
      }
    } else {
      CustomDialogs.customErrorDialog(
        context,
        'RFID Tag Blank',
        'The RFID Tag is currently blank. Please fill it with the corresponding Id No. to proceed.'
      );
    }
  }
}