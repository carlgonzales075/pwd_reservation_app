import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/register/drivers/file_upload.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
// import 'package:pwd_reservation_app/modules/shared/drivers/camera.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final List<File?> _selectedImages = List.generate(3, (_) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload ID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Select either a PWD or a Senior Citizen ID:'),
            const BasicStringDropDownMenu(),
            const SizedBox(height: 10.0),
            _buildCameraButton(0, 'Front of ID', _selectedImages),
            const SizedBox(height: 10.0),
            _buildCameraButton(1, 'Back of ID', _selectedImages),
            const SizedBox(height: 10.0),
            _buildCameraButton(2, 'Selfie', _selectedImages),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                List<String> imageIds = await uploadImages(
                  context.read<DomainProvider>().url as String,
                  context.read<CredentialsProvider>().accessToken as String,
                  _selectedImages
                ) as List<String>;
                // print(imageIds);
                if (context.mounted) {
                  try {
                    await postImageProcessing(
                      context.read<DomainProvider>().url as String,
                      context.read<CredentialsProvider>().accessToken as String,
                      imageIds,
                      context.read<PassengerProvider>().id as String
                    );
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Application Submitted'),
                            content: const Text('We received your application and we will review it and get back within 48 hours.'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Back')
                              )
                            ],
                          );
                        }
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Failed Upload'),
                            content: const Text('An error occurred while uploading.'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Back')
                              )
                            ],
                          );
                        }
                      );
                    }
                  }
                  
                }
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraButton(int index, String label, List<File?> selectedImages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10.0),
        CameraButtonHelper(
          selectedImages: selectedImages,
          index: index,
        ),
      ],
    );
  }
}

class CameraButtonHelper extends StatefulWidget {
  const CameraButtonHelper({
    super.key, required this.selectedImages, required this.index
  });

  // final void Function(File? image) onImageSelected;
  final List<File?> selectedImages;
  final int index;

  @override
  State<CameraButtonHelper> createState() => _CameraButtonHelperState();
}

class _CameraButtonHelperState extends State<CameraButtonHelper> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100.0,
      child: GestureDetector(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image
          );

          if (result != null) {
            setState(() {
              _selectedImage = File(result.files.single.path!);
              widget.selectedImages[widget.index] = _selectedImage;
            });
          }
        },
        child: _selectedImage == null ? 
        const Card(child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_rounded),
              SizedBox(width: 20.0),
              Text('Placeholder1'),
            ],
          )
        ))
        : Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        )
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