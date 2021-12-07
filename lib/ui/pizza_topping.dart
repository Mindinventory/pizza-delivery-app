import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_delivery/cubit/pizza_cubit.dart';
import 'package:pizza_delivery/extensions/dimension_extension.dart';
import 'package:pizza_delivery/ui/curve_carousel/curve_carousel.dart';
import 'package:pizza_delivery/viewmodel/pizza_viewmodel.dart';

class PizzaToppingListView extends StatelessWidget {
  final PageController pageController = PageController(viewportFraction: 0.2);

  PizzaToppingListView({Key? key}) : super(key: key);
  List<ToppingItemModel> listItem = <ToppingItemModel>[];
  @override
  Widget build(BuildContext context) {
    listItem = BlocProvider.of<PizzaCubit>(context, listen: false).toppingList;
    return BlocConsumer<PizzaCubit, PizzaState>(
      listener: (context, state) {
        if (state is PizzaChangedState) {
          for (int i = 0; i < listItem.length; i++) {
            listItem[i].selected = false;
          }
        }
      },
      builder: (context, state) {
        return FractionallySizedBox(
        widthFactor: 1,
        child: CurvedCarousel(
          itemBuilder: (context, i) {
            return ToppingItem(
              img: listItem[i].img,
              selectionChange: (value) {
                listItem[i].selected = value;
                if (value) {
                  BlocProvider.of<PizzaCubit>(context)
                      .addTopping(context, listItem[i]);
                } else {
                  BlocProvider.of<PizzaCubit>(context)
                      .removeTopping(listItem[i]);
                }
              },
              selected: listItem[i].selected,
              key: ValueKey(listItem[i].selected),
            );
          },
          itemCount: listItem.length,
          middleItemScaleRatio: 1.5,
        ),
      );
      }
    );
  }
}

class ToppingItem extends StatefulWidget {
  const ToppingItem({
    Key? key,
    required this.img,
    required this.selectionChange,
    required this.selected,
  }) : super(key: key);
  final String img;
  final bool selected;
  final void Function(bool) selectionChange;

  @override
  State<ToppingItem> createState() => _ToppingItemState();
}

class _ToppingItemState extends State<ToppingItem> {
  bool? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          selected = !(selected ?? widget.selected);
          setState(() {});
          widget.selectionChange.call(selected!);
        },
        child: Center(
          child: Opacity(
            opacity: selected ?? widget.selected ? 0.3 : 1,
            child: Image.asset(
              widget.img,
              width: 55.toSize(context),
              height: 55.toSize(context),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
