import 'package:disposable_tool/provider/generate_json.dart';
import 'package:flutter/material.dart';

import 'input_field.dart';

class KeyForm extends StatefulWidget {
  const KeyForm(this.provider, {super.key});

  final GenerateJsonProvider provider;

  @override
  State<KeyForm> createState() => _KeyFormState();
}

class _KeyFormState extends State<KeyForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        var state = _formKey.currentState;
        state?.save();
        debugPrint('改变了');
        widget.provider.format();
      },
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          children: List.generate(
            widget.provider.keyNum,
            (index) => InputField(
              onSaved: (value) => widget.provider.addKey(index, value!),
            ),
          ),
        ),
      ),
    );
  }
}
