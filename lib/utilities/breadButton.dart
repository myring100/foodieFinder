import 'package:flutter/material.dart';

class CloudButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CloudButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          _CloudShapeBorder(),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud,
              color: Colors.blue,
            ),
            SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudShapeBorder extends OutlinedBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(4.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addPath(getOuterPath(rect, textDirection: textDirection), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final center = Offset(rect.center.dx, rect.center.dy);
    final radius = rect.shortestSide / 2.0;

    path.moveTo(rect.left, center.dy);
    path.arcToPoint(
      Offset(rect.right, center.dy),
      radius: Radius.elliptical(radius, radius / 2),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(rect.left, center.dy),
      radius: Radius.elliptical(radius, radius / 2),
      clockwise: false,
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return this;
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}