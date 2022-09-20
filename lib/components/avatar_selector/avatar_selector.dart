import 'package:flutter/material.dart';

class AvatarSelector extends StatelessWidget {
  final Function onChange;
  const AvatarSelector({Key? key, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => onChange(0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFFF7E7E)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(1),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFFFBC7E)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(2),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFFCFF7E)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(3),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFAFFF7E)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(4),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFF7EFFE0)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(5),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFF7EE8FF)),
                height: 42,
                width: 42,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => onChange(6),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFF817EFF)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(7),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFC67EFF)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(8),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFFF7EB4)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(9),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFEB9898)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(10),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFF469990)),
                height: 42,
                width: 42,
              ),
            ),
            GestureDetector(
              onTap: () => onChange(11),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFA9A9A9)),
                height: 42,
                width: 42,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
