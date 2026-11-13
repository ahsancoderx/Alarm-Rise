import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import 'math_questions.dart';

class MathMission extends StatefulWidget {
  final VoidCallback onSolved;
  final int total;
  const MathMission({super.key, required this.onSolved, this.total = 3});

  @override
  State<MathMission> createState() => _MathMissionState();
}

class _MathMissionState extends State<MathMission> {
  final _rng = Random();
  final _controller = TextEditingController();
  late List<MathQuestion> _questions;
  int _index = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _questions =
        (List<MathQuestion>.of(mathQuestions)..shuffle(_rng)).take(widget.total).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    if (value == null) return;

    if (value == _questions[_index].answer) {
      _controller.clear();
      if (_index + 1 >= widget.total) {
        widget.onSolved();
      } else {
        setState(() {
          _index++;
          _error = null;
        });
      }
    } else {
      // Galat jawab: naya sawal do
      final fresh = mathQuestions.where((q) => !_questions.contains(q)).toList();
      setState(() {
        _questions[_index] = fresh[_rng.nextInt(fresh.length)];
        _error = 'Wrong answer. Here is a new question.';
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question ${_index + 1} of ${widget.total}',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: AppColors.textSecondary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _index / widget.total,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.orange,
          backgroundColor: AppColors.border,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              q.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'))],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            hintText: 'Your answer',
            errorText: _error,
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 60,
          child: FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Submit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}