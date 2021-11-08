import 'dart:ui';

import 'package:pizza_delivery/ui/custom_painters.dart';

enum PizzaSize { small, medium, large }

class PizzaViewModel {
  final String name;
  final String description;
  final String imgPath;
  final double price;
  late final List<Topping> appliedToppings;

  PizzaViewModel(
      {required this.name,
      required this.description,
      required this.imgPath,
      required this.price}) {
    appliedToppings = [];
  }
}

class Topping {
  final String name;
  final String img;
  final String unitImg;
  final List<Pos> positions;

  Topping(this.name, this.img, this.unitImg, this.positions);
}

class ToppingItemModel {
  bool selected=false;
  final String name;
  final String img;
  final String unitImg;
  final double price;
  final int limit;

  ToppingItemModel(this.name, this.img, this.unitImg, this.limit, this.price);
}
