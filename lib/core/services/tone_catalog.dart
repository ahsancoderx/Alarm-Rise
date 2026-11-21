import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ToneOption {
  final String id; // "assets/tones/x.mp3" ya "file:/abs/path"
  final String name;
  const ToneOption(this.id, this.name);
}

class ToneCatalog {
  static const customPrefix = 'file:';
  static const fallbackAsset = 'assets/tones/alarm.mp3';
  static final _audioExt =
      RegExp(r'\.(mp3|m4a|aac|wav|ogg|flac)$', caseSensitive: false);

  static bool isCustom(String id) => id.startsWith(customPrefix);
  static String customPath(String id) => id.substring(customPrefix.length);

  static String _pretty(String path) {
    final base = p
        .basenameWithoutExtension(path)
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .trim();
    if (base.isEmpty) return 'Tone';
    return base[0].toUpperCase() + base.substring(1);
  }

  static String displayName(String id) {
    if (isCustom(id)) return _pretty(customPath(id));
    if (id.startsWith('assets/')) return _pretty(id);
    return 'Default tone'; // purane alarms ke naam
  }

  /// assets/tones/ ke andar jo bhi audio files hain.
  static Future<List<ToneOption>> builtIn() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((a) => a.startsWith('assets/tones/') && _audioExt.hasMatch(a))
        .toList()
      ..sort();
    return [for (final a in paths) ToneOption(a, _pretty(a))];
  }

  /// User ki apni import ki hui tones.
  static Future<List<ToneOption>> customTones() async {
    final docs = await getApplicationDocumentsDirectory();
    final root = Directory(p.join(docs.path, 'alarm_tones'));
    if (!await root.exists()) return [];
    final out = <ToneOption>[];
    await for (final e in root.list(recursive: true)) {
      if (e is File && _audioExt.hasMatch(e.path)) {
        out.add(ToneOption('$customPrefix${e.path}', _pretty(e.path)));
      }
    }
    out.sort((a, b) => a.name.compareTo(b.name));
    return out;
  }

  /// Gallery/phone se chuni hui file ko app ke folder mein copy karta hai,
  /// taake baad mein permission ya path ka masla na ho.
  static Future<String> importFile(String sourcePath, String name) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(
        docs.path, 'alarm_tones', DateTime.now().millisecondsSinceEpoch.toString()));
    await dir.create(recursive: true);
    final dest = p.join(dir.path, name);
    await File(sourcePath).copy(dest);
    return '$customPrefix$dest';
  }

  /// Alarm package ko dene wala asli path. File gum ho to default tone.
  static Future<String> resolve(String id) async {
    if (isCustom(id)) {
      final path = customPath(id);
      return await File(path).exists() ? path : fallbackAsset;
    }
    if (id.startsWith('assets/')) return id;
    return fallbackAsset;
  }
}