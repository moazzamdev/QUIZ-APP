import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const RoundButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 105, vertical: 0),
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 20,
          ),

          shape: const StadiumBorder(),

          elevation: 12,
          shadowColor: Colors.black87,
          alignment: Alignment
              .center, // Center the content horizontally and vertically
        ),
        child:
            // Example icon, you can replace this with your content

            Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
