import 'package:flutter/material.dart';

class CloudTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CloudTextButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipPath(
          clipper: CloudClipper(),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.8, 0);
    path.quadraticBezierTo(size.width, size.height * 0.5, size.width * 0.8, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.quadraticBezierTo(0, size.height * 0.5, size.width * 0.2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
