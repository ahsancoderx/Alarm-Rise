import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/photo_service.dart';
import 'math_mission.dart';

class PhotoMission extends StatefulWidget {
  final IconData icon;
  final String instruction;
  final String referencePath; // khali = koi reference nahi
  final Future<PhotoCheck> Function(String path) verify;
  final VoidCallback onSolved;

  const PhotoMission({
    super.key,
    required this.icon,
    required this.instruction,
    required this.verify,
    required this.onSolved,
    this.referencePath = '',
  });

  @override
  State<PhotoMission> createState() => _PhotoMissionState();
}

class _PhotoMissionState extends State<PhotoMission> {
  static const _maxFails = 5;

  bool _busy = false;
  int _fails = 0;
  PhotoCheck? _last;
  String? _lastPath;

  Future<void> _capture() async {
    setState(() => _busy = true);
    try {
      final path = await PhotoService.takePhoto();
      if (path == null) {
        if (mounted) setState(() => _busy = false);
        return;
      }
      final result = await widget.verify(path);
      if (!mounted) return;
      if (result.passed) {
        widget.onSolved();
        return;
      }
      setState(() {
        _fails++;
        _last = result;
        _lastPath = path;
        _busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _fails++;
        _last = PhotoCheck(false, 'Could not read the photo. Try again.', const []);
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fails >= _maxFails) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Camera not working? Solve 5 questions instead.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 16),
          MathMission(total: 5, onSolved: widget.onSolved),
        ],
      );
    }

    final refExists = widget.referencePath.isNotEmpty &&
        File(widget.referencePath).existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(widget.icon, size: 40, color: AppColors.orange),
                const SizedBox(height: 12),
                Text(
                  widget.instruction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                if (refExists) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(File(widget.referencePath),
                        height: 160, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 6),
                  const Text('Your spot',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_last != null) ...[
          if (_lastPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(File(_lastPath!), height: 140, fit: BoxFit.cover),
            ),
          const SizedBox(height: 8),
          Text(
            _last!.message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red.shade600, fontWeight: FontWeight.w700),
          ),
          if (_last!.labels.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Detected: ${_last!.labels.take(6).join(', ')}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Attempt $_fails of $_maxFails',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: 64,
          child: FilledButton.icon(
            onPressed: _busy ? null : _capture,
            icon: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.camera_alt_rounded),
            label: Text(
              _busy ? 'Checking photo...' : 'Take photo',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}