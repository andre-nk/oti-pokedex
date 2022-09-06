import 'package:flutter/material.dart';

//? Pokemon Stat Box
class PokemonStat extends StatelessWidget {
  final IconData icon;
  final dynamic value;
  final String statName;
  const PokemonStat({
    Key? key,
    required this.icon,
    required this.value,
    required this.statName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            statName.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
