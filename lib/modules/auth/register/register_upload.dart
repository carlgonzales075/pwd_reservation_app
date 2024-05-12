import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
// import 'package:pwd_reservation_app/modules/shared/drivers/camera.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomThemeColors.themeBlue,
        elevation: 0,
        title: const Text(
                'Upload ID',
                style: TextStyle(
                  color: CustomThemeColors.themeWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
        )
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Select either a PWD or a Senior Citizen ID:'),
            SizedBox(height: 10.0),
            BasicStringDropDownMenu(),
            SizedBox(height: 10.0),
            Text('Front of ID'),
            CameraButtonHelper(),
            SizedBox(height: 10.0),
            Text('Back of ID'),
            CameraButtonHelper(),
            SizedBox(height: 10.0),
            Text('Selfie'),
            CameraButtonHelper(),
            UploadCreateAccount()
          ],
        ),
      ),
    );
  }
}

class CameraButtonHelper extends StatelessWidget {
  const CameraButtonHelper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100.0,
      child: GestureDetector(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null) {
            print(result.files.first.name);
          }
        },
        child: const Card(child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_rounded),
              SizedBox(width: 20.0),
              Text('Placeholder1'),
            ],
          )
        )),
      ));
  }
}

class UploadCreateAccount extends StatefulWidget {
  const UploadCreateAccount({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadCreateAccount createState() => _UploadCreateAccount();
}

class _UploadCreateAccount extends State<UploadCreateAccount> {
  final bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        BasicElevatedButton(
          buttonText: 'Create Account',
          onPressed: () {
            if (isComplete) {
              Navigator.pushNamed(context, '/home');
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const DetailsDialog(); // Show the custom dialog
                },
              );
            }
          }
        ),
      ],
    );
  }
}

enum IconLabel {
  senior('Senior Citizen ID', Icons.elderly_sharp),
  pwd('PWD ID', Icons.wheelchair_pickup_sharp);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class BasicStringDropDownMenu extends StatefulWidget {
  const BasicStringDropDownMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BasicStringDropDownMenu createState() => _BasicStringDropDownMenu();
}

class _BasicStringDropDownMenu extends State<BasicStringDropDownMenu> {
  final TextEditingController iconController = TextEditingController();
  IconLabel? selectedIcon;

  @override
  Widget build (BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: DropdownMenu<IconLabel>(
        controller: iconController,
        requestFocusOnTap: true,
        label: const Text('ID Type'),
        onSelected: (IconLabel? icon) {
          setState(() {
            selectedIcon = icon;
          });
        },
        dropdownMenuEntries:
            IconLabel.values.map<DropdownMenuEntry<IconLabel>>(
          (IconLabel icon) {
            return DropdownMenuEntry<IconLabel>(
              value: icon,
              label: icon.label,
              leadingIcon: Icon(icon.icon),
            );
          },
        ).toList()
      ) 
    );
  }
}

class DetailsDialog extends StatelessWidget {
  const DetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Complete Details'),
      content: const Text('Please complete all the details to proceed.'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}