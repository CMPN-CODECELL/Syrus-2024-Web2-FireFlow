import 'package:flutter/material.dart';

class ToggleIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final bool value;
  final Icon onIcon;
  final Icon offIcon;

  const ToggleIcon({
    Key? key,
    required this.onPressed,
    required this.value,
    required this.onIcon,
    required this.offIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: value ? onIcon : offIcon,
    );
  }
}
