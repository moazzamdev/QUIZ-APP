import 'package:flutter/material.dart';

class ProfileMenuWidget2 extends StatefulWidget {
  const ProfileMenuWidget2({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  _ProfileMenuWidget2State createState() => _ProfileMenuWidget2State();
}

class _ProfileMenuWidget2State extends State<ProfileMenuWidget2> {
  late bool endIconState; // Declare endIconState here

  @override
  void initState() {
    super.initState();
    endIconState = true; // Initialize endIconState as needed
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black.withOpacity(0.1),
        ),
        child: Icon(widget.icon, color: Colors.black),
      ),
      title: Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.apply(color: widget.textColor),
      ),
      trailing: widget.endIcon
          ? Switch(
              value: endIconState,
              onChanged: (newValue) {
                setState(() {
                  endIconState = newValue;
                });
              },
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.1),
            )
          : null,
    );
  }
}
