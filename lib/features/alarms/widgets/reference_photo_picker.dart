import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/photo_service.dart';

class ReferencePhotoPicker extends StatefulWidget {
  final String path;
  final void Function(String path, String labels) onPicked;

  const ReferencePhotoPicker({
    super.key,
    required this.path,
    required this.onPicked,
  });

  @override
  State<ReferencePhotoPicker> createState() => _ReferencePhotoPickerState();
}

class _ReferencePhotoPickerState extends State<ReferencePhotoPicker> {
  bool _busy = false;
  String? _error;

  Future<void> _pick() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final tmp = await PhotoService.takePhoto();
      if (tmp == null) {
        setState(() => _busy = false);
        return;
      }
      final labels =
          await PhotoService.label(tmp, threshold: PhotoService.roomThreshold);
      if (labels.length < 3) {
        setState(() {
          _busy = false;
          _error = 'Photo is not clear enough. Retake it in better light, '
              'with the spot filling the frame.';
        });
        return;
      }
      final saved = await PhotoService.saveReference(tmp);
      widget.onPicked(saved, labels.map((l) => l.label).join('|'));
      setState(() => _busy = false);
    } catch (e) {
      setState(() {
        _busy = false;
        _error = 'Could not take the photo. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final has = widget.path.isNotEmpty && File(widget.path).existsSync();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Take a photo of a spot you must walk to, like your washroom '
              'sink or kitchen. In the morning you will photograph the same spot.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            if (has)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(File(widget.path),
                    height: 160, fit: BoxFit.cover),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!,
                    style: TextStyle(color: Colors.red.shade600)),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _busy ? null : _pick,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.camera_alt_rounded),
              label: Text(has ? 'Retake photo' : 'Take reference photo'),
            ),
          ],
        ),
      ),
    );
  }
}