import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class CameraApp extends StatefulWidget {
  const CameraApp({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      XFile pictureFile = await _controller.takePicture();
      
      setState(() {
        _capturedImage = File(pictureFile.path);
      });

      // Navigate to display the captured image on a new screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(imageFile: _capturedImage!),
          ),
        );
      }

    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera App'),
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildCameraPreview();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _takePicture,
          child: const Icon(Icons.camera),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_capturedImage == null) {
      return const Center(
        child: Text(
          'Capture an image',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(_capturedImage!),
          ],
        ),
      );
    }
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final File imageFile;

  const DisplayPictureScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Picture')),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
