import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../models/document_model.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isProcessing = false;
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.high,
        enableAudio: false);
    await _controller!.initialize();
    await _controller!.setFlashMode(FlashMode.off);
    if (mounted) {
      setState(() => _isCameraInitialized = true);
    }
  }

  void _toggleFlash() async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!
          .setFlashMode(_isFlashOn ? FlashMode.off : FlashMode.torch);
      setState(() => _isFlashOn = !_isFlashOn);
    }
  }

  Future<void> _captureAndProcess() async {
    if (!_controller!.value.isInitialized) return;

    setState(() => _isProcessing = true);

    try {
      final file = await _controller!.takePicture();
      final croppedFile = await _cropTextRegion(File(file.path));
      if (croppedFile != null) {
        await _processImage(croppedFile);
      } else {
        debugPrint('No text region detected for cropping.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No document detected to crop.')),
        );
      }
    } catch (e) {
      debugPrint('Capture error: $e');
    }

    setState(() => _isProcessing = false);
  }

  Future<File?> _cropTextRegion(File originalImage) async {
    final inputImage = InputImage.fromFilePath(originalImage.path);
    final recognizedText = await textRecognizer.processImage(inputImage);

    if (recognizedText.blocks.isEmpty) return null;

    double left = double.infinity;
    double top = double.infinity;
    double right = double.negativeInfinity;
    double bottom = double.negativeInfinity;

    for (final block in recognizedText.blocks) {
      final rect = block.boundingBox;
      if (rect != null) {
        left = rect.left < left ? rect.left : left;
        top = rect.top < top ? rect.top : top;
        right = rect.right > right ? rect.right : right;
        bottom = rect.bottom > bottom ? rect.bottom : bottom;
      }
    }

    final bytes = await originalImage.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final croppedImage = await image.toByteData(format: ui.ImageByteFormat.png);
    final ui.Rect cropRect = Rect.fromLTRB(left, top, right, bottom);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(image, cropRect,
        Rect.fromLTWH(0, 0, cropRect.width, cropRect.height), Paint());
    final cropped = await recorder
        .endRecording()
        .toImage(cropRect.width.toInt(), cropRect.height.toInt());
    final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);

    final dir = await getApplicationDocumentsDirectory();
    final croppedPath = p.join(
        dir.path, 'cropped_${DateTime.now().millisecondsSinceEpoch}.png');
    final file = File(croppedPath)
      ..writeAsBytesSync(byteData!.buffer.asUint8List());

    return file;
  }

  Future<void> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final result = await textRecognizer.processImage(inputImage);
    String text = result.text.toLowerCase();

    String type = 'Unknown';
    if (text.contains('aadhaar') ||
        RegExp(r'\d{4} \d{4} \d{4}').hasMatch(text)) {
      type = 'Aadhaar Card';
    } else if (text.contains('income tax') ||
        RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]{1}').hasMatch(text)) {
      type = 'PAN Card';
    } else if (text.contains('gst')) {
      type = 'GST Document';
    } else if (text.contains('account number')) {
      type = 'Bank Statement';
    }

    Provider.of<DocumentProvider>(context, listen: false).addDocument(
      DocumentData(
        filePath: imageFile.path,
        type: type,
        extractedFields: {
          'Type': type,
          'Preview': text.length > 100 ? '${text.substring(0, 100)}...' : text,
        },
      ),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$type scanned successfully')));
  }

  Future<void> _pickFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final cropped = await _cropTextRegion(File(pickedFile.path));
      if (cropped != null) {
        await _processImage(cropped);
      }
    }
  }

  Widget _controlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
          onPressed: _toggleFlash,
        ),
        const SizedBox(width: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.camera),
          label: const Text('Scan'),
          onPressed: _isProcessing ? null : _captureAndProcess,
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.photo_library),
          onPressed: _pickFromGallery,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isCameraInitialized
        ? SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Align document and press Scan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(child: CameraPreview(_controller!)),
                const SizedBox(height: 10),
                _controlButtons(),
                const SizedBox(height: 10),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
