import 'dart:io';
import 'dart:math';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PhotoCheck {
  final bool passed;
  final String message;
  final List<String> labels; // jo ML Kit ne dekha

  const PhotoCheck(this.passed, this.message, this.labels);
}

class PhotoService {
  // Inhein tune kar sakte ho (neeche notes dekho)
  static const skyThreshold = 0.45;
  static const roomThreshold = 0.4;
  static const roomMatchRatio = 0.4; // reference labels ka kitna hissa match ho

  static const _skyWords = {
    'sky', 'cloud', 'sun', 'sunset', 'sunrise', 'dusk', 'dawn',
    'horizon', 'atmosphere', 'daytime', 'sunlight', 'twilight', 'moon',
    'afterglow',
  };

  static final _picker = ImagePicker();

  /// Sirf camera. Gallery allow nahi.
  static Future<String?> takePhoto() async {
    final x = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1280,
    );
    return x?.path;
  }

  static Future<List<ImageLabel>> label(String path,
      {double threshold = 0.5}) async {
    final labeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: threshold),
    );
    try {
      return await labeler.processImage(InputImage.fromFilePath(path));
    } finally {
      await labeler.close();
    }
  }

  /// Reference photo ko app ke permanent folder mein copy karta hai.
  static Future<String> saveReference(String tempPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(dir.path, 'reference_photos'))
      ..createSync(recursive: true);
    final dest = p.join(
        folder.path, 'ref_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await File(tempPath).copy(dest);
    return dest;
  }

  static Future<PhotoCheck> verifySky(String path) async {
    final labels = await label(path, threshold: skyThreshold);
    final names = labels.map((l) => l.label).toList();
    final ok = names.any((n) => _skyWords.contains(n.toLowerCase()));
    return PhotoCheck(
      ok,
      ok
          ? 'Sky verified'
          : 'Sky not detected. Point the camera at the open sky.',
      names,
    );
  }

  static Future<PhotoCheck> verifyRoom(String refCsv, String path) async {
    final ref = refCsv
        .split('|')
        .where((e) => e.isNotEmpty)
        .map((e) => e.toLowerCase())
        .toSet();

    final labels = await label(path, threshold: roomThreshold);
    final names = labels.map((l) => l.label).toList();

    // Reference hi kharab ho to user ko na phansao
    if (ref.length < 2) {
      return PhotoCheck(true, 'No reference available', names);
    }

    final now = names.map((e) => e.toLowerCase()).toSet();
    final shared = ref.intersection(now);
    final needed = max(2, (ref.length * roomMatchRatio).ceil());
    final ok = shared.length >= needed;

    return PhotoCheck(
      ok,
      ok
          ? 'Place verified'
          : 'This does not look like your spot (${shared.length}/$needed matched).',
      names,
    );
  }
}