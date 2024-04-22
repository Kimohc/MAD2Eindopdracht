import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle( // Specify the style here
        fontFamily: 'YourFontFamily',
        // Change this to your desired font family
        fontSize: 16,
        // Change this to your desired font size
        fontWeight: FontWeight.normal,
        // Change this to your desired font weight
        color: Colors.black, // Change this to your desired text color
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
      ),
      obscureText: obscureText,
    );
  }
}