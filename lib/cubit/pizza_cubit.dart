import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pizza_delivery/ui/custom_painters.dart';
import 'package:pizza_delivery/viewmodel/pizza_viewmodel.dart';

part 'pizza_state.dart';

class PizzaCubit extends Cubit<PizzaState> {
  List<Topping> toppings = [];

  final List<PizzaViewModel> pizzaList = [
    PizzaViewModel(
        name: 'Pizza 1',
        description: 'This pizza is very tasty',
        imgPath: 'assets/images/pizza1.png',
        price: 6.00),
    PizzaViewModel(
        name: 'Pizza 2',
        description: 'This pizza is very delicious',
        imgPath: 'assets/images/pizza2.png',
        price: 7.00),
    PizzaViewModel(
        name: 'Pizza 3',
        description: 'This pizza is very amazing',
        imgPath: 'assets/images/pizza3.png',
        price: 15.0),
    PizzaViewModel(
        name: 'Pizza 4',
        description: 'This pizza is very delicious',
        imgPath: 'assets/images/pizza4.png',
        price: 5.00),
    PizzaViewModel(
        name: 'Pizza 5',
        description: 'This pizza is very delicious',
        imgPath: 'assets/images/pizza5.png',
        price: 20.00),
    PizzaViewModel(
        name: 'Pizza 6',
        description: 'This pizza is very delicious',
        imgPath: 'assets/images/pizza6.png',
        price: 13.00),
  ];
  final List<ToppingItemModel> toppingList = [
    // 'assets/images/toppings/green_peppers_thumb.png',
    // 'assets/images/toppings/halloumi_thumb.png',
    // 'assets/images/toppings/mushrooms_thumb.png',
    // 'assets/images/toppings/olives_thumb.png',
    // 'assets/images/toppings/onions_thumb.png',
    // 'assets/images/toppings/pineapples_thumb.png',
    // 'assets/images/toppings/sweetcorn_thumb.png',
    // 'assets/images/toppings/tomatos_thumb.png',
    ToppingItemModel(
        'name',
        'assets/images/toppings/green_chillies_thumb.png',
        'assets/images/toppings/unit/green_chillies_thumb.png',
        100),
    ToppingItemModel(
        'name',
        'assets/images/toppings/onions_thumb.png',
        'assets/images/toppings/unit/onions_thumb_unit.png',
        10,),
    ToppingItemModel(
        'name',
        'assets/images/toppings/pineapples_thumb.png',
        'assets/images/toppings/unit/pineapples_thumb_unit.png',
        30),
    ToppingItemModel(
        'name',
        'assets/images/toppings/halloumi_thumb.png',
        'assets/images/toppings/unit/halloumi_thumb_unit.png',
        30),
    ToppingItemModel(
        'name',
        'assets/images/toppings/mushrooms_thumb.png',
        'assets/images/toppings/unit/mushrooms_thumb.png',
        30),
    ToppingItemModel(
        'name',
        'assets/images/toppings/sweetcorn_thumb.png',
        'assets/images/toppings/unit/sweetcorn_thumb_unit.png',
        30),
  ];
  PizzaSize pizzaSize = PizzaSize.medium;
  int selectedPizza = 1;

  PizzaCubit() : super(PizzaInitial());

  double getPizzaSize(PizzaSize size) {
    switch (size) {
      case PizzaSize.medium:
        return 230;
      case PizzaSize.small:
        return 200;
      case PizzaSize.large:
        return 280;
    }
  }

  void addTopping(BuildContext context, ToppingItemModel toppingItemModel) {
    final random = Random.secure();
    final deviceWidth = MediaQuery.of(context).size.width;
    final calculatedPizzaSize = getPizzaSize(pizzaSize);
    const centerY = 70 + (350 / 2);
    final rSquare = (calculatedPizzaSize - 50) * (calculatedPizzaSize - 50) / 4;
    toppings.add(Topping(
        toppingItemModel.name,
        toppingItemModel.img,
        toppingItemModel.unitImg,
        List.generate(toppingItemModel.limit, (index) {
          late int x, y;
          do {
            x = random.nextInt(deviceWidth.toInt());
            y = random.nextInt(deviceWidth.toInt()+70);
          } while (
              pow((deviceWidth / 2) - x, 2) + pow(centerY - y, 2) > rSquare);
          return Pos(x, y);
        })));
    emit(PizzaToppingChangeState());
  }

  void removeTopping( ToppingItemModel toppingItemModel){
    toppings.removeWhere((element) => element.img==toppingItemModel.img);
    emit(PizzaToppingChangeState());
  }
}
