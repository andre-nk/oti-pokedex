import 'package:flutter/material.dart';

class LoadingIndicatorPage extends StatelessWidget {
  const LoadingIndicatorPage({Key? key}) : super(key: key);

  //Custom loading indicator
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/pikachu_loading.gif",
        height: 64,
        width: 64,
      ),
    );
  }
}
