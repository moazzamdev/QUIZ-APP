import 'package:flutter/material.dart';

class LoginContent extends StatefulWidget {
  final String hint;
  final IconData iconData;
  final TextEditingController controller;
  final bool hiden;
  const LoginContent({
    Key? key,
    required this.hint,
    required this.iconData,
    required this.controller,
    required this.hiden,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            obscureText: widget.hiden,
            controller: widget.controller,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: widget.hint,
              prefixIcon: Icon(widget.iconData),
            ),
          ),
        ),
      ),
    );
  }
}
