import 'package:flutter/material.dart';

class SearchBarButton extends StatelessWidget {
  SearchBarButton({
    this.icon,
    this.color,
    this.onPressed,
    this.size = defaultSize,
    this.padding = defaultPadding,
  });

  static const defaultSize = 24.0;
  static const defaultPadding = EdgeInsets.all(12.0);

  final IconData icon;
  final Color color;
  final GestureTapCallback onPressed;
  final double size;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        margin: padding,
        child: Icon(icon, color: color, size: 24.0),
      ),
    );
  }
}
