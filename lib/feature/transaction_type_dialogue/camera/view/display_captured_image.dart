import 'dart:io';
import 'package:flutter/material.dart';

class DisplayCapturedImagePage extends StatelessWidget {
  final String imagePath;

  const DisplayCapturedImagePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Image')),
      body: Center(child: Image.file(File(imagePath), fit: BoxFit.contain)),
    );
  }
}
