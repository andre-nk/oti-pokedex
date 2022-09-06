import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pagination_view/pagination_view.dart';

import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/view/screens/error_page.dart';
import 'package:pokedex/view/screens/loading_indicator_page.dart';
import 'package:pokedex/view/widgets/pokedex_card.dart';
import 'package:pokedex/view/widgets/pokedex_carousel.dart';
import 'package:pokedex/view/widgets/pokedex_header.dart';
import 'package:pokedex/view/widgets/pokedex_icon.dart';
import 'package:pokedex/viewmodel/pokedex_icon_viewmodel.dart';
import 'package:pokedex/viewmodel/pokedex_viewmodel.dart';

class PokedexPage extends HookConsumerWidget {
  PokedexPage({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //? Safe provider declarations
    final pokedexController = ref.watch(pokedexProvider);
    final pokedexSearchController = ref.watch(pokedexSearchProvider);
    final favoritePokemonController = ref.watch(favoritePokemonProvider);
    final iconStatusController = ref.watch(iconStatusProvider);

    //? ScrollController for the sticky Pokemon logo button
    scrollController.addListener(() async {
      double currentScroll = scrollController.position.pixels;

      if (currentScroll != 0) {
        ref.read(iconStatusProvider.notifier).state = true;
      } else {
        ref.read(iconStatusProvider.notifier).state = false;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned(
              top: -2,
              left: -1,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: iconStatusController ? 1.0 : 0.0,
                child: const PokedexIcon(),
              ),
            ),

            //? Reactive pokedexSearchController
            pokedexSearchController.when(
              data: ((data) {
                //? Conditionals (ternary) for determining whether the data from search mode is available
                return data.isEmpty
                    //? If not, display the usual Pokedex list with PaginationView Library
                    ? PaginationView<Pokemon>(
                        key: key,
                        preloadedItems: pokedexController.value!,
                        paginationViewType: PaginationViewType.listView,
                        itemBuilder: (BuildContext context, Pokemon pokemon, int index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                const PokedexHeader(),
                                favoritePokemonController.when(
                                  data: ((data) {
                                    if (data.isNotEmpty) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 8.0),
                                        child: PokedexCarousel(
                                          pokemonList: data,
                                        ),
                                      );
                                    } else {
                                      data = [...pokedexController.value!];
                                      data.shuffle();

                                      return Padding(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 8.0),
                                        child: PokedexCarousel(
                                          pokemonList: data.sublist(0, 10),
                                        ),
                                      );
                                    }
                                  }),
                                  error: (error, _) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: PokedexCarousel(
                                        pokemonList:
                                            pokedexController.value!.sublist(0, 10),
                                      ),
                                    );
                                  },
                                  loading: (() {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                                ),
                                Container(
                                  height: 16,
                                  margin: const EdgeInsets.only(top: 24.0),
                                  width: double.infinity,
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                )
                              ],
                            );
                          } else {
                            return PokedexCard(
                              pokemon: pokedexController.value![index - 1],
                              pokedexSearchIndex: -1,
                            );
                          }
                        },
                        pageFetch: (int offset) {
                          return ref.read(pokedexProvider.notifier).fetchPokemons();
                        },
                        pullToRefresh: true,
                        onError: (dynamic error) =>
                            ErrorPage(errorMessage: error.toString()),
                        onEmpty: const ErrorPage(errorMessage: "No data is found"),
                        bottomLoader: Container(
                          margin: const EdgeInsets.all(8.0),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        initialLoader: const LoadingIndicatorPage(),
                      )

                    //? If there is the search data, display a regular ListView builder
                    : ListView.builder(

                        //The item count is incremented by one for accomodating the custom Header widget
                        //So that the Header widget can be incorporated into the scroll experience
                        itemCount: data.length + 1,
                        itemBuilder: ((context, index) {
                          if (index == 0) {
                            return const PokedexHeader();
                          } else {
                            return PokedexCard(
                              pokemon: data[index - 1],
                              pokedexSearchIndex: index - 1,
                            );
                          }
                        }),
                      );
              }),

              //? Error handler
              error: ((error, _) {
                return ErrorPage(errorMessage: error.toString());
              }),

              //? Default loading page
              loading: (() {
                return const LoadingIndicatorPage();
              }),
            )
          ].reversed.toList(),
        ),
      ),
    );
  }
}
