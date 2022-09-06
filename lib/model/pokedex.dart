import 'dart:convert';

//? Custom Pokedex model for fetching '/pokemons' route on PokeAPI
// use toJson and fromJson for a normal parse into Map data type
// and use toRawJson and fromRawJson for parsing this class into a String data type
class Pokedex {
    Pokedex({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    int count;
    String next;
    dynamic previous;
    List<PokedexEntry> results;

    factory Pokedex.fromRawJson(String str) => Pokedex.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Pokedex.fromJson(Map<String, dynamic> json) => Pokedex(
        count: json["count"],
        next: json["next"] ?? "",
        previous: json["previous"] ?? "",
        results: List<PokedexEntry>.from(json["results"].map((x) => PokedexEntry.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class PokedexEntry {
    PokedexEntry({
        required this.name,
        required this.url,
    });

    String name;
    String url;

    factory PokedexEntry.fromRawJson(String str) => PokedexEntry.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PokedexEntry.fromJson(Map<String, dynamic> json) => PokedexEntry(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}
