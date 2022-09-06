import 'package:flutter/material.dart';

//? Pokemon Logo Icon Clipper (Inner)
class InnerIconClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width*0.7678571,size.height*0.9824561);
    path_0.lineTo(size.width*0.01785714,size.height*0.9824561);
    path_0.lineTo(size.width*0.01785714,size.height*0.01754386);
    path_0.lineTo(size.width*0.9821429,size.height*0.01754386);
    path_0.lineTo(size.width*0.9821429,size.height*0.7719298);
    path_0.lineTo(size.width*0.7678571,size.height*0.9824561);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

class OuterIconClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width*0.7685183,size.height*0.9848213);
    path_0.lineTo(size.width*0.01666667,size.height*0.9848213);
    path_0.lineTo(size.width*0.01666667,size.height*0.01639344);
    path_0.lineTo(size.width*0.9833333,size.height*0.01639344);
    path_0.lineTo(size.width*0.9833333,size.height*0.7735279);
    path_0.lineTo(size.width*0.7685183,size.height*0.9848213);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}