import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pokedex/view/widgets/pokedex_search_dialog.dart';
import 'package:pokedex/viewmodel/pokedex_icon_viewmodel.dart';
import 'package:pokedex/viewmodel/pokedex_viewmodel.dart';


//? General Pokedex Header widget 
class PokedexHeader extends HookConsumerWidget {
  const PokedexHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconStatusController = ref.watch(iconStatusProvider);
    final pokedexSearchController = ref.watch(pokedexSearchProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: iconStatusController ? 0.0 : 1.0,
            child: SvgPicture.asset(
              "assets/logo.svg",
              height: 48,
              width: 48,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: pokedexSearchController.when(
              data: (data) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(data.isEmpty ? "" : "${data.length} pokemon(s) found"),
                    ),
                    IconButton(
                      splashColor:
                          Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      splashRadius: 12.0,
                      onPressed: () {
                        if (data.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const PokedexSearchDialog();
                            },
                          );
                        } else {
                          ref.read(pokedexSearchProvider.notifier).state =
                              const AsyncValue.data([]);
                        }
                      },
                      icon: Icon(
                        data.isEmpty ? Ionicons.search : Ionicons.close,
                        size: 28,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                );
              },
              loading: () {
                return const Text("Searching...");
              },
              error: (error, _) {
                return IconButton(
                  splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  splashRadius: 12.0,
                  onPressed: () {
                    ref.read(pokedexSearchProvider.notifier).state =
                        const AsyncValue.data([]);
                  },
                  icon: Icon(
                    Ionicons.search,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
