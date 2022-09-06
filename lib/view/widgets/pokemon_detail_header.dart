import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/view/screens/pokedex_page.dart';
import 'package:pokedex/viewmodel/pokedex_viewmodel.dart';

//? Pokemon Detail Page Header
class PokemonDetailHeader extends HookConsumerWidget {
  final Pokemon pokemon;
  const PokemonDetailHeader({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePokemonController = ref.watch(favoritePokemonProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            splashRadius: 12.0,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => PokedexPage()),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(
              Ionicons.arrow_back,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          favoritePokemonController.when(
            data: (data) {
              if (data.where((element) => element.id == pokemon.id).isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    splashRadius: 12.0,
                    onPressed: () {
                      ref
                          .read(favoritePokemonProvider.notifier)
                          .removeFavoritePokemon(pokemon);
                    },
                    icon: Icon(
                      Ionicons.heart,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    splashRadius: 12.0,
                    onPressed: () {
                      ref
                          .read(favoritePokemonProvider.notifier)
                          .addFavoritePokemon(pokemon);
                    },
                    icon: Icon(
                      Ionicons.heart_outline,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, stackTrace) {
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
