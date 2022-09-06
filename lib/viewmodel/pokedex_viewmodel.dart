import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pokedex/const/dio_exceptions.dart';
import 'package:pokedex/model/pokedex.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/repository/pokemon_repository.dart';

//? Next 20 Pokemons (fetch link)
final pokedexNextCursorProvider = StateProvider<String>((ref) {
  return "";
});

//? Pokemons from Search Mode state
final pokedexSearchProvider = StateProvider<AsyncValue<List<Pokemon>>>((ref) {
  return const AsyncValue.data([]);
});


//? Pokedex StateNotifier Provider
final pokedexProvider =
    StateNotifierProvider<PokedexNotifier, AsyncValue<List<Pokemon>>>((ref) {
  return PokedexNotifier((ref.read));
});


//? Pokedex StateNotifier class
class PokedexNotifier extends StateNotifier<AsyncValue<List<Pokemon>>> {

  //Riverpod reader for reading repository provider
  final Reader _reader;

  PokedexNotifier(this._reader) : super(const AsyncValue.data([]));

  //Fetch pokemons
  Future<List<Pokemon>> fetchPokemons() async {
    try {
      //Read and store next batch's link
      final String nextCursor = _reader(pokedexNextCursorProvider);

      //Fetch next batch's pokedex
      final Pokedex pokemonListModel;

      if (nextCursor.isEmpty) {
        pokemonListModel =
            await _reader(pokemonRepositoryProvider).getInitialPokemonCursor();
      } else {
        pokemonListModel = await _reader(pokemonRepositoryProvider)
            .getMorePokemonCursor(nextCursor.substring(26, nextCursor.length));
      }

      //Update the newest next cursor batch
      _reader(pokedexNextCursorProvider.notifier).state = pokemonListModel.next;

      //Fetch the current batch's pokemons
      final List<Pokemon> pokemonList =
          await _reader(pokemonRepositoryProvider).getPokemonsData(pokemonListModel);

      //Update local state pokemons
      state = AsyncValue.data([...state.value!, ...pokemonList]);

      return pokemonList;
    } on DioException catch (e) {
      state = AsyncValue.error(e.message);
      return [];
    }
  }

  Future<void> searchPokemon(String query) async {
    try {
      //Set loading mode
      _reader(pokedexSearchProvider.notifier).state = const AsyncValue.loading();

      //Fetch pokemons
      final List<Pokemon> result = [];
      final Pokedex allPokemonCursor =
          await _reader(pokemonRepositoryProvider).getAllPokemonCursor();

      List<PokedexEntry> filteredEntries = allPokemonCursor.results.where((entry) {
        return entry.name.contains(query.toLowerCase());
      }).toList();

      for (var entry in filteredEntries) {
        final Pokemon pokemonData =
            await _reader(pokemonRepositoryProvider).getPokemonInfo(entry.name);
        result.add(pokemonData);
      }

      //Update state with pokemon list
      _reader(pokedexSearchProvider.notifier).state = AsyncValue.data(result);
    } on DioException catch (e) {
      state = AsyncValue.error(e.message);
    }
  }
}

//Favorite pokemon state notifier provider
final favoritePokemonProvider =
    StateNotifierProvider<FavoritePokemonNotifier, AsyncValue<List<Pokemon>>>((ref) {
  return FavoritePokemonNotifier(ref.read)..getFavoritePokemons();
});

//Favorite pokemon StateNotifier class
class FavoritePokemonNotifier extends StateNotifier<AsyncValue<List<Pokemon>>> {
  final Reader _reader;

  FavoritePokemonNotifier(this._reader) : super(const AsyncValue.data([]));

  Future<void> addFavoritePokemon(Pokemon pokemon) async {
    try {
      state = const AsyncValue.loading();
      await _reader(pokemonRepositoryProvider).addFavoritePokemon(pokemon);
      await getFavoritePokemons();
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> removeFavoritePokemon(Pokemon pokemon) async {
    try {
      state = const AsyncValue.loading();
      await _reader(pokemonRepositoryProvider).removeFavoritePokemon(pokemon);
      await getFavoritePokemons();
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> getFavoritePokemons() async {
    try {
      state = const AsyncValue.loading();
      final List<Pokemon> favoritePokemons =
          await _reader(pokemonRepositoryProvider).getFavoritePokemons();
      state = AsyncValue.data(favoritePokemons);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}
