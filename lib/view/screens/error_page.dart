import 'package:flutter/material.dart';
import 'package:pokedex/view/screens/pokedex_page.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  const ErrorPage({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/thrubbish_error.gif",
                    height: 128,
                    width: 128,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      children: [
                        Text(
                          "Uh-oh",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          errorMessage,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //Custom button for getting back to homepage
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => PokedexPage()),
                      (Route<dynamic> route) => false);
                },
                child: const Text(
                  "Back to Home",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
