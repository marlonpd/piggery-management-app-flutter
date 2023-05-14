import 'package:flutter/material.dart';
import 'package:pma/helpers/global_variables.dart';

class CustomBtn extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool isLoading;

  const CustomBtn({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<CustomBtn> createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return ElevatedButton.icon(
        onPressed: widget.isLoading ? null : widget.onTap,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.fromLTRB(20, 8, 20, 8)),
        icon: Container(
          width: 24,
          height: 24,
          padding: const EdgeInsets.all(2.0),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ),
        label: Text(widget.text),
      );
    } else {
      return ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onTap,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.fromLTRB(20, 8, 20, 8)),
        child: Text(widget.text),
      );
    }
  }
}
