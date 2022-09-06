import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/const/dio_exceptions.dart';
import 'package:pokedex/const/general_providers.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/model/pokedex.dart';

//? Pokemon repository provider
final pokemonRepositoryProvider = Provider<PokemonRepositoryAPI>((ref) {
  return PokemonRepositoryAPI(ref.read);
});

//? Pokemon repository abstract class
// This abstract class is soon to be useful for easier mock testing
abstract class PokemonRepository {
  Future<Pokedex> getInitialPokemonCursor();
  Future<Pokedex> getMorePokemonCursor(String next);
  Future<Pokedex> getAllPokemonCursor();
  Future<List<Pokemon>> getPokemonsData(Pokedex pokemonListModel);
  Future<Pokemon> getPokemonInfo(String pokemonName);
  Future<void> addFavoritePokemon(Pokemon pokemon);
  Future<void> removeFavoritePokemon(Pokemon pokemon);
  Future<List<Pokemon>> getFavoritePokemons();
}


//? Pokemon repository implementations
class PokemonRepositoryAPI implements PokemonRepository {
  final Reader reader;

  PokemonRepositoryAPI(this.reader);

  //Fetch pokemons (Pokedex model) list (only 20 pokemons / call)
  @override
  Future<Pokedex> getInitialPokemonCursor() async {
    try {
      final response = await reader(dioProvider).get("pokemon?limit=20");
      final Pokedex pokemonListModel = Pokedex.fromJson(response.data);

      return pokemonListModel;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }

  //Fetch next pokemons list (20 more pokemons) from the next field
  @override
  Future<Pokedex> getMorePokemonCursor(String next) async {
    try {
      final response = await reader(dioProvider).get(next);

      final Pokedex pokemonListModel = Pokedex.fromJson(response.data);
      return pokemonListModel;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }


  //Fetch all pokemons list (for searching only)
  @override
  Future<Pokedex> getAllPokemonCursor() async {
    try {
      final response = await reader(dioProvider).get("pokemon?limit=1200");

      final Pokedex pokemonListModel = Pokedex.fromJson(response.data);

      return pokemonListModel;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }


  //Fetch each pokemon data (the actual Pokemon model)
  //Called after Pokedex model is fetched and valid
  @override
  Future<List<Pokemon>> getPokemonsData(Pokedex pokemonListModel) async {
    try {
      List<Pokemon> pokemonListOutput = [];
      for (var pokemon in pokemonListModel.results) {
        final pokemonResponse = await getPokemonInfo(pokemon.name);

        pokemonListOutput.add(pokemonResponse);
      }

      return pokemonListOutput;
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }

  //Fetch single complete pokemon info (Pokemon model)
  @override
  Future<Pokemon> getPokemonInfo(String pokemonName) async {
    try {
      final response = await reader(dioProvider).get("pokemon/$pokemonName");

      return Pokemon.fromJson(response.data);
    } on DioError catch (e) {
      throw DioException.fromDioError(e);
    }
  }

  //Add a pokemon model to the local storage as a favorite
  @override
  Future<void> addFavoritePokemon(Pokemon pokemon) async {
    try {
      reader(sharedPrefProvider).whenData((sharedPref) {
        final List<String>? currentFavoritePokemons =
            sharedPref.getStringList('favoritePokemon');

        if (currentFavoritePokemons != null) {
          sharedPref.setStringList(
            'favoritePokemon',
            [...currentFavoritePokemons, pokemon.toRawJson()],
          );
        } else {
          sharedPref.setStringList(
            'favoritePokemon',
            [pokemon.toRawJson()],
          );
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  //Remove a pokemon model from local storage
  @override
  Future<void> removeFavoritePokemon(Pokemon pokemon) async {
    try {
      final List<Pokemon> favoritePokemons = await getFavoritePokemons();

      favoritePokemons.removeWhere((element) => element.id == pokemon.id);

      List<String> rawPokemons = [];
      for (var pokemon in favoritePokemons) {
        rawPokemons.add(pokemon.toRawJson());
      }

      reader(sharedPrefProvider).whenData((sharedPref) {
        sharedPref.setStringList(
          'favoritePokemon',
          rawPokemons,
        );
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  //Fetch all favorite pokemons from the local storage
  @override
  Future<List<Pokemon>> getFavoritePokemons() async {
    try {
      List<Pokemon> favoritePokemons = [];

      reader(sharedPrefProvider).whenData((sharedPref) {
        final List<String>? favoritePokemonsRaw =
            sharedPref.getStringList('favoritePokemon');

        if (favoritePokemonsRaw != null) {
          for (var rawPokemon in favoritePokemonsRaw) {
            favoritePokemons.add(Pokemon.fromRawJson(rawPokemon));
          }
        }
      });

      return favoritePokemons;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
