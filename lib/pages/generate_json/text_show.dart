import 'package:flutter/material.dart';

class TextShow extends StatelessWidget {
  const TextShow({
    super.key,
    required this.controller,
    required this.hintText,
    required this.buttonText,
    required this.onPressed,
  });

  final TextEditingController controller;
  final String hintText;
  final String buttonText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 8.0, top: 8.0),
                isCollapsed: true,
              ),
              maxLines: null,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ColoredBox(
              color: Colors.white,
              child: TextButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
