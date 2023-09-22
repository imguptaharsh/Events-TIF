import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const Color kPrimaryColor = Color.fromRGBO(86, 105, 255, 1);
const Color kSecondaryColor = Colors.white;

class SVGIcon extends StatelessWidget {
  final String icon;
  const SVGIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      // color: Color.fromARGB(255, 79, 28, 246),
    );
  }
}
