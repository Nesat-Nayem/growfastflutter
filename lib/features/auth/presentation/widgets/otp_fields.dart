import 'package:flutter/material.dart';
import 'package:grow_first/core/utils/sizing.dart';

class AnimatedOtpFields extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;

  const AnimatedOtpFields({
    super.key,
    this.length = 6,
    required this.onCompleted,
  });

  @override
  State<AnimatedOtpFields> createState() => _AnimatedOtpFieldsState();
}

class _AnimatedOtpFieldsState extends State<AnimatedOtpFields> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _focusNodes.first.requestFocus();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index + 1 != widget.length) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        String otp = _controllers.map((e) => e.text).join();
        widget.onCompleted(otp);
        FocusScope.of(context).unfocus();
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  Widget _buildOtpBox(int index) {
    const double size = 50;

    return SizedBox(
      width: size,
      height: size,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center, // 👈 IMPORTANT
        maxLength: 1,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          isDense: true, // 👈 removes extra padding
          contentPadding: allPadding12, // 👈 perfect centering
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size / 2),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size / 2),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        onChanged: (value) => _onChanged(value, index),
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, _buildOtpBox),
    );
  }
}
