enum PizzaSize{
  small,
  medium,
  large
}

class PizzaViewModel{
  final String name;
  final String description;
  final String imgPath;
  PizzaSize size;
  final double price;
  PizzaViewModel( {required this.name,required this.description,required this.imgPath,this.size=PizzaSize.medium,required this.price,});
}