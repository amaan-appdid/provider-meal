import 'package:flutter/material.dart';

class FullScreen extends StatefulWidget {
  const FullScreen({super.key, required this.imgUrl, required this.text});
  final String imgUrl;
  final String text;

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.text),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.network(
                widget.imgUrl,
                height: MediaQuery.of(context).size.height,
              ),
            )
          ],
        ),
      ),
    );
  }
}
