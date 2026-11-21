import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/tone_catalog.dart';

class TonePickerSheet extends StatefulWidget {
  final String selected;
  const TonePickerSheet({super.key, required this.selected});

  @override
  State<TonePickerSheet> createState() => _TonePickerSheetState();
}

class _TonePickerSheetState extends State<TonePickerSheet> {
  final _player = AudioPlayer();
  List<ToneOption> _builtIn = [];
  List<ToneOption> _custom = [];
  bool _loading = true;
  String? _playing;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = null);
    });
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      ToneCatalog.builtIn(),
      ToneCatalog.customTones(),
    ]);
    if (!mounted) return;
    setState(() {
      _builtIn = results[0];
      _custom = results[1];
      _loading = false;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _preview(ToneOption t) async {
    if (_playing == t.id) {
      await _player.stop();
      setState(() => _playing = null);
      return;
    }
    await _player.stop();
    final source = ToneCatalog.isCustom(t.id)
        ? DeviceFileSource(ToneCatalog.customPath(t.id))
        : AssetSource(t.id.replaceFirst('assets/', ''));
    try {
      await _player.play(source);
      setState(() => _playing = t.id);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not play this sound')),
        );
      }
    }
  }

  Future<void> _pickFromPhone() async {
    await _player.stop();
    final file = await FilePicker.pickFile(type: FileType.audio);
    final path = file?.path;
    if (file == null || path == null) return;
    final id = await ToneCatalog.importFile(path, file.name);
    if (mounted) Navigator.of(context).pop(id);
  }

  Widget _tile(ToneOption t) {
    final selected = t.id == widget.selected;
    final playing = t.id == _playing;
    return ListTile(
      leading: IconButton(
        icon: Icon(
          playing ? Icons.stop_circle_rounded : Icons.play_circle_rounded,
          color: AppColors.orange,
          size: 32,
        ),
        onPressed: () => _preview(t),
      ),
      title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing:
          selected ? const Icon(Icons.check_rounded, color: AppColors.orange) : null,
      onTap: () => Navigator.of(context).pop(t.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: FilledButton.icon(
                      onPressed: _pickFromPhone,
                      icon: const Icon(Icons.folder_open_rounded),
                      label: const Text('Choose from phone'),
                    ),
                  ),
                  if (_custom.isNotEmpty) ...[
                    const _Header('My tones'),
                    for (final t in _custom) _tile(t),
                  ],
                  const _Header('Built-in'),
                  if (_builtIn.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No built-in tones found in assets/tones/'),
                    ),
                  for (final t in _builtIn) _tile(t),
                ],
              ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
      );
}