import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/view/widgets/pokedex_about_sheet.dart';
import 'package:pokedex/view/widgets/pokedex_icon_paint.dart';

//? Pokemon Icon Logo Clipper
class PokedexIcon extends StatelessWidget {
  const PokedexIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          builder: ((context) {
            return const PokedexAboutSheet();
          }),
        );
      },
      splashColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
      child: ClipPath(
        clipper: OuterIconClipper(),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipPath(
            clipper: InnerIconClipper(),
            child: Container(
              color: Theme.of(context).colorScheme.background,
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12.0,
              ),
              child: SvgPicture.asset(
                "assets/logo.svg",
                height: 48,
                width: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
