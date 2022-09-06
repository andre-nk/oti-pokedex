import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/const/general_providers.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/view/screens/pokedex_detail_page.dart';

class PokedexCarousel extends StatelessWidget {
  final List<Pokemon> pokemonList;
  const PokedexCarousel({Key? key, required this.pokemonList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //? CarouselSlider for featured or favorite pokemons
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.4,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enlargeCenterPage: true,
      ),
      items: pokemonList
          .map(
            (pokemon) => InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return PokedexDetailPage(
                    pokedexIndex: pokemon.id - 1,
                    pokedexSearchIndex: -1,
                  );
                }));
              },
              splashColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(
                    0.2,
                  ),
              child: Container(
                margin: const EdgeInsets.all(2.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: pokemon.getTypeColors().length == 1
                            ? BoxDecoration(color: pokemon.getTypeColors().first)
                            : BoxDecoration(
                                gradient: LinearGradient(
                                  colors: pokemon.getTypeColors(),
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            top: 64.0,
                            bottom: 20.0,
                          ),
                          child: Center(
                            child: Text(
                              pokemon.name.capitalize(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 36.0),
                        child: Center(
                          child: Image.network(
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png",
                            height: 148,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
