import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';
import 'package:pwd_reservation_app/modules/users/utils/upload_image.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<File?> selectedImages = [null]; // Assuming only one image for simplicity

  void handleImageSelected(File? image) {
    setState(() {
      selectedImages[0] = image;
    });
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              color: CustomThemeColors.themeWhite
          ),
          child: Padding(
              padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                EditProfileHelper(
                  selectedImages: selectedImages,
                  onImageSelected: handleImageSelected,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomThemeColors.themeBlue,
                      foregroundColor: CustomThemeColors.themeWhite,
                      minimumSize: const Size.fromHeight(50)
                    ),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image
                      );

                      if (result != null) {
                        File? selectedImage = await SimpleImage.compressImage(File(result.files.single.path!));
                        setState(() {
                          handleImageSelected(selectedImage); // Notify parent of the new image
                        });
                      }
                    },
                    child: const Text('Edit Profile Picture')
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: CustomThemeColors.themeWhite,
            minimumSize: const Size.fromHeight(50)
          ),
          onPressed: () async {
            if (selectedImages[0] != null) {
              try {
                dynamic id = await SimpleImage.uploadImage(
                  context.read<DomainProvider>().url as String,
                  context.read<CredentialsProvider>().accessToken as String,
                  selectedImages[0] as File
                );
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Upload Successful'),
                        content: const Text('Your new profile picture is uploaded successfully!'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              context.read<UserProvider>().updateAvatar(id);
                              try {
                                await SimpleImage.updateAvatar(
                                  context.read<DomainProvider>().url as String,
                                  context.read<CredentialsProvider>().accessToken as String,
                                  context.read<UserProvider>().userId as String,
                                  id
                                );
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('An error occured'),
                                        content: Text('An unexpected error occured. $e'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK')
                                          )
                                        ],
                                      );
                                    }
                                  );
                                }
                              }
                            },
                            child: const Text('Confirm')
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
                        title: const Text('Error on Uploading'),
                        content: Text('An unexpected error occurred. $e'),
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
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('No image selected'),
                    content: const Text('Please select an image before confirming.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {Navigator.of(context).pop();},
                        child: const Text('OK')
                      )
                    ],
                  );
                }
              );
            }
          },
          child: const Text('Confirm')
        )
      ],
    );
  }
}

class EditProfileHelper extends StatefulWidget {
  const EditProfileHelper({
    super.key,
    required this.selectedImages,
    required this.onImageSelected
  });

  // final void Function(File? image) onImageSelected;
  final List<File?> selectedImages;
  final void Function(File? image) onImageSelected;

  @override
  State<EditProfileHelper> createState() => _EditProfileHelper();
}

class _EditProfileHelper extends State<EditProfileHelper> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.0,
      child: GestureDetector(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image
          );

          if (result != null) {
            File selectedImage = File(result.files.single.path!);
            setState(() {
              widget.onImageSelected(selectedImage); // Notify parent of the new image
            });
          }
        },
        child: widget.selectedImages[0] == null ? 
        const SizedBox(
          height: 180,
          width: 180,
          child: EditProfileImage(
            width: 200,
            height: 200,
            scale: false,
          ),
        )
        // : Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: Image.file(
        //         widget.selectedImages[0]!,
        //         fit: BoxFit.contain,
        //         width: double.infinity,
        //       ),
        //     ),
        //   ),
        // )
        : ClipOval(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: FileImage(widget.selectedImages[0]!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      )
    );
  }
}