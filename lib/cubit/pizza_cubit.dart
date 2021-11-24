import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pizza_delivery/core/res/app_assets.dart';
import 'package:pizza_delivery/core/res/app_strings.dart';
import 'package:pizza_delivery/extensions/context_extension.dart';
import 'package:pizza_delivery/extensions/dimension_extension.dart';
import 'package:pizza_delivery/ui/custom_painters.dart';
import 'package:pizza_delivery/viewmodel/pizza_viewmodel.dart';

part 'pizza_state.dart';

class PizzaCubit extends Cubit<PizzaState> {
  List<Topping> toppings = [];

  final List<PizzaViewModel> pizzaList = [
    PizzaViewModel(
      name: AppStrings.pizza1,
      description: AppStrings.pizzaDes1,
      imgPath: AppAssets.pizza1,
      price: 6.00,
    ),
    PizzaViewModel(
      name: AppStrings.pizza2,
      description: AppStrings.pizzaDes2,
      imgPath: AppAssets.pizza2,
      price: 7.00,
    ),
    PizzaViewModel(
      name: AppStrings.pizza3,
      description: AppStrings.pizzaDes3,
      imgPath: AppAssets.pizza3,
      price: 15.0,
    ),
    PizzaViewModel(
      name: AppStrings.pizza4,
      description: AppStrings.pizzaDes4,
      imgPath: AppAssets.pizza4,
      price: 5.00,
    ),
    PizzaViewModel(
      name: AppStrings.pizza5,
      description: AppStrings.pizzaDes4,
      imgPath: AppAssets.pizza5,
      price: 20.00,
    ),
    PizzaViewModel(
      name: AppStrings.pizza6,
      description: AppStrings.pizzaDes4,
      imgPath: AppAssets.pizza6,
      price: 13.00,
    ),
  ];
  final List<ToppingItemModel> toppingList = [
    ToppingItemModel(
      'name',
      AppAssets.greenChilliesThumb,
      AppAssets.unitGreenChilliesThumb,
      100,
      7,
    ),
    ToppingItemModel(
      'name',
      AppAssets.onionsThumb,
      AppAssets.unitOnionsThumb,
      90,
      4,
    ),
    ToppingItemModel(
      'name',
      AppAssets.pineapplesThumb,
      AppAssets.unitPineapplesThumb,
      200,
      2,
    ),
    ToppingItemModel(
      'name',
      AppAssets.halloumiThumb,
      AppAssets.unitHalloumiThumb,
      80,
      0.7,
    ),
    ToppingItemModel(
      'name',
      AppAssets.mushroomsThumb,
      AppAssets.unitMushroomsThumb,
      30,
      2,
    ),
    ToppingItemModel(
      'name',
      AppAssets.sweetcornThumb,
      AppAssets.unitSweetcornThumb,
      90,
      0.5,
    ),
  ];
  PizzaSize pizzaSize = PizzaSize.medium;
  int selectedPizza = 0;

  PizzaCubit() : super(PizzaInitial());

  double _getPizzaSize(PizzaSize size, BuildContext context) {
    switch (size) {
      case PizzaSize.small:
        return 160.toSize(context);
      case PizzaSize.medium:
        return 195.toSize(context);
      case PizzaSize.large:
        return 230.toSize(context);
    }
  }

  void addTopping(BuildContext context, ToppingItemModel toppingItemModel) {
    final random = Random.secure();
    final deviceWidth = context.width;
    final calculatedPizzaSize = _getPizzaSize(pizzaSize, context);
    final centerY = (((context.width < 394) ? 30.toSize(context) : 55.toSize(context)) + (345.toSize(context) / 2));
    final startingXofPizza = ((deviceWidth / 2) - (calculatedPizzaSize / 2));
    final startingYOfPizza = ((context.width < 394) ? 30.toSize(context) : 55.toSize(context)) + ((340.toSize(context) - calculatedPizzaSize) / 2);
    final rSquare = (calculatedPizzaSize - (40.toSize(context))) * (calculatedPizzaSize - (40.toSize(context))) / 4;

    toppings.add(
      Topping(
        toppingItemModel.name,
        toppingItemModel.img,
        toppingItemModel.unitImg,
        List.generate(toppingItemModel.limit, (index) {
          late int x, y;
          do {
            x = (startingXofPizza + (calculatedPizzaSize.toInt() * random.nextInt(5000) / 5000.0)).toInt();
            y = (startingYOfPizza + (calculatedPizzaSize.toInt() * random.nextInt(5000) / 5000.0)).toInt();
          } while (pow(((deviceWidth - 25) / 2) - x, 2) + pow(centerY - y, 2) > rSquare);
          return Pos(x, y, (100 + (random.nextInt(5000)/100)) / 100.0);
        }),
      ),
    );
    emit(PizzaToppingChangeState(toppingItemModel, true));
  }

  void removeTopping(ToppingItemModel toppingItemModel) {
    toppings.removeWhere((element) => element.img == toppingItemModel.img);
    emit(PizzaToppingChangeState(toppingItemModel, false));
  }

  void changePizzaState(bool isRightSwipe) {
    if (toppings.isNotEmpty) {
      toppings.clear();
      toppingList.forEach((element) => element.selected = false);
    }
    emit(PizzaChangeState(rightSide: isRightSwipe));
  }

  void changePizzaSize(PizzaSize old) {
    if (toppings.isNotEmpty) {
      toppings.clear();
      toppingList.forEach((element) => element.selected = false);
    }
    emit(PizzaChangeSizeState(old));
  }
}
