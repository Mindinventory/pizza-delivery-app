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

  Topping(this.name, this.img, this.unitImg);
}
