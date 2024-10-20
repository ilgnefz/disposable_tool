import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({super.key, this.onSaved});

  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              spreadRadius: 0,
              blurRadius: 2,
            )
          ]),
      child: TextFormField(
        decoration: const InputDecoration.collapsed(
          hintText: '输入JSON键名',
          hintStyle: TextStyle(fontSize: 14.0),
        ),
        style: const TextStyle(fontSize: 14.0),
        onSaved: onSaved,
      ),
    );
  }
}
