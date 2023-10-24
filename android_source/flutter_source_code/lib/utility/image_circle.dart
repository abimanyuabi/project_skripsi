import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

Widget svgToCricleImage(
    {required String stringAssetLink, required double diameter}) {
  return SizedBox(
    width: diameter,
    height: diameter,
    child: CircleAvatar(
      backgroundImage: Svg(stringAssetLink),
    ),
  );
}

Widget pngToCircleImage(
    {required ImageProvider imageProv, required double diameter}) {
  return SizedBox(
    width: diameter,
    height: diameter,
    child: CircleAvatar(
      backgroundImage: imageProv,
      backgroundColor: Colors.white,
    ),
  );
}
