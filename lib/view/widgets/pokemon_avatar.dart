import 'package:flutter/material.dart';
import 'package:pokedex/model/pokemon.dart';

//? Pokemon Avatar widget
class PokemonAvatar extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonAvatar({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: pokemon.id - 1,
      child: Image.network(
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png",
        height: 90,
        width: 90,
        fit: BoxFit.cover,
      ),
    );
  }
}
