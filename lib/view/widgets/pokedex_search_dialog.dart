import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pokedex/viewmodel/pokedex_viewmodel.dart';

//? Pokemon Search Dialog
class PokedexSearchDialog extends HookConsumerWidget {
  const PokedexSearchDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Icon(Ionicons.search),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 9,
              child: TextField(
                onSubmitted: ((value) {
                  ref.read(pokedexProvider.notifier).searchPokemon(value);
                  Navigator.pop(context);
                }),
                decoration:
                    const InputDecoration.collapsed(hintText: "Search any pokemon..."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
