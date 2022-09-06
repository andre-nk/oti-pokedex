import 'package:flutter/material.dart';

//App's about sheet for additional informations
class PokedexAboutSheet extends StatelessWidget {
  const PokedexAboutSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "What is this app about?",
            style: Theme.of(context).textTheme.headline5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Image.asset("assets/pokeapi_logo.png"),
              ),
              Text(
                "   x",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Expanded(
                flex: 2,
                child: Image.asset("assets/omahti_logo.png"),
              ),
            ],
          ),
          Text(
            "This Pokedex app is designed and developed for application project in OmahTI Open Recruitment (Mobile App Division) in 2022.\n \n Following the basic requirements, the author designed this app with some modern looks and some additional features such as image caching, and favorite Pokemons!",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
