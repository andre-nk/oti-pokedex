import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokedex/const/general_providers.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/view/widgets/pokemon_detail_header.dart';
import 'package:pokedex/view/widgets/pokemon_stat.dart';
import 'package:pokedex/viewmodel/pokedex_viewmodel.dart';

class PokedexDetailPage extends HookConsumerWidget {
  final int pokedexSearchIndex;
  final int pokedexIndex;
  const PokedexDetailPage({
    Key? key,
    required this.pokedexIndex,
    required this.pokedexSearchIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokedexController = ref.watch(pokedexProvider);
    final pokedexSearchController = ref.watch(pokedexSearchProvider);

    //? Conditionals for determining whether the passed Pokemon model is from search mode or homepage
    Pokemon pokemonData;
    if (pokedexSearchIndex == -1) {
      pokemonData = pokedexController.value![pokedexIndex];
    } else {
      pokemonData = pokedexSearchController.value![pokedexSearchIndex];
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PokemonDetailHeader(
              pokemon: pokemonData,
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: pokedexSearchIndex == -1
                          ? pokedexIndex != 0
                              ? 1.0
                              : 0.2
                          : pokedexSearchIndex != 0
                              ? 1.0
                              : 0.2,
                      child: IconButton(
                        splashRadius: 16,
                        splashColor:
                            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        onPressed: () {
                          if (pokedexSearchIndex == -1) {
                            if (pokedexIndex != 0) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: PokedexDetailPage(
                                    pokedexIndex: pokedexIndex - 1,
                                    pokedexSearchIndex: -1,
                                  ),
                                  type: PageTransitionType.leftToRightJoined,
                                  childCurrent: this,
                                ),
                              );
                            }
                          } else if (pokedexSearchIndex != 0) {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: PokedexDetailPage(
                                  pokedexIndex: pokedexIndex - 1,
                                  pokedexSearchIndex: pokedexSearchIndex - 1,
                                ),
                                type: PageTransitionType.leftToRightJoined,
                                childCurrent: this,
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Ionicons.chevron_back,
                          size: 40,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Hero(
                        tag: pokedexIndex,
                        child: CachedNetworkImage(
                          imageUrl: pokemonData.sprites.frontDefault,
                          errorWidget: (ctx, e, _) {
                            return Text(e.toString());
                          },
                          progressIndicatorBuilder: ((context, url, progress) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: pokedexSearchIndex == -1
                          ? pokedexController.value!.length != pokedexIndex + 1
                              ? 1.0
                              : 0.2
                          : pokedexSearchController.value!.length !=
                                  pokedexSearchIndex + 1
                              ? 1.0
                              : 0.2,
                      child: IconButton(
                        onPressed: () {
                          if (pokedexSearchIndex == -1) {
                            if (pokedexController.value!.length != pokedexIndex + 1) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: PokedexDetailPage(
                                    pokedexIndex: pokedexIndex + 1,
                                    pokedexSearchIndex: -1,
                                  ),
                                  type: PageTransitionType.rightToLeftJoined,
                                  childCurrent: this,
                                ),
                              );
                            }
                          } else if (pokedexSearchController.value!.length !=
                              pokedexSearchIndex + 1) {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: PokedexDetailPage(
                                  pokedexIndex: pokedexIndex + 1,
                                  pokedexSearchIndex: pokedexSearchIndex + 1,
                                ),
                                type: PageTransitionType.rightToLeftJoined,
                                childCurrent: this,
                              ),
                            );
                          }
                        },
                        splashRadius: 16,
                        splashColor:
                            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        icon: const Icon(
                          Ionicons.chevron_forward,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        "No. ${pokemonData.id}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      pokemonData.name.capitalize(),
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Wrap(
                        spacing: 12.0,
                        children:
                            List.generate(pokemonData.getTypeColors().length, (index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: pokemonData.getTypeColors()[index],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Text(
                                pokemonData.types[index].type.name.capitalize(),
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(top: 64.0),
                padding: const EdgeInsets.symmetric(
                  vertical: 28.0,
                  horizontal: 32.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            PokemonStat(
                              icon: Ionicons.heart_circle_outline,
                              statName: "HP",
                              value: pokemonData.stats[0].baseStat,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: PokemonStat(
                                icon: Ionicons.shield_half,
                                statName: "SP Def",
                                value: pokemonData.stats[4].baseStat,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            PokemonStat(
                              icon: Ionicons.arrow_up_circle_outline,
                              statName: "Attack",
                              value: pokemonData.stats[1].baseStat,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: PokemonStat(
                                icon: Ionicons.sunny_outline,
                                statName: "SP Attack",
                                value: pokemonData.stats[3].baseStat,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            PokemonStat(
                              icon: Ionicons.shield_outline,
                              statName: "Defense",
                              value: pokemonData.stats[2].baseStat,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: PokemonStat(
                                icon: Ionicons.flash_outline,
                                statName: "Speed",
                                value: pokemonData.stats[5].baseStat,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
