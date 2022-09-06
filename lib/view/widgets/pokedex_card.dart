import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/const/general_providers.dart';
import 'package:pokedex/view/screens/pokedex_detail_page.dart';
import 'package:pokedex/view/widgets/pokemon_avatar.dart';
import 'package:pokedex/viewmodel/pokedex_viewmodel.dart';

class PokedexCard extends HookConsumerWidget {
  final int pokedexSearchIndex;
  final Pokemon pokemon;
  const PokedexCard({Key? key, required this.pokemon, required this.pokedexSearchIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePokemonController = ref.watch(favoritePokemonProvider);

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {

          //Go to each Pokemon's details page
          return PokedexDetailPage(
            pokedexIndex: pokemon.id - 1,
            pokedexSearchIndex: pokedexSearchIndex,
          );
        }));
      },
      splashColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.125,
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  margin: const EdgeInsets.symmetric(vertical: 16).copyWith(
                    right: 20,
                  ),
                  child: Column(
                    children: List.generate(pokemon.getTypeColors().length, (index) {
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(

                            //Get typeColors() for gradient background
                            color: pokemon.getTypeColors()[index],
                            borderRadius: BorderRadius.only(
                              topRight: index % 2 == 0
                                  ? const Radius.circular(8.0)
                                  : Radius.zero,
                              bottomRight:
                                  index % 2 != 0 || pokemon.getTypeColors().length == 1
                                      ? const Radius.circular(8.0)
                                      : Radius.zero,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No. ${pokemon.id}"),
                    Text(
                      pokemon.name.capitalize(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),

              //Fetch and check if this pokemon is a favorite
              child: favoritePokemonController.when(
                data: (data) {
                  if (data.where((element) => element.id == pokemon.id).isNotEmpty) {
                    return Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        PokemonAvatar(pokemon: pokemon),
                        Positioned(
                          right: 8,
                          child: Icon(
                            Ionicons.heart,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return PokemonAvatar(pokemon: pokemon);
                  }
                },
                error: (error, _) {
                  return PokemonAvatar(pokemon: pokemon);
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
