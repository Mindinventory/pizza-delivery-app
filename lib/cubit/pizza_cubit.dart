import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pizza_delivery/viewmodel/pizza_viewmodel.dart';

part 'pizza_state.dart';

class PizzaCubit extends Cubit<PizzaState> {
  final List<PizzaViewModel> pizzaList=[
    PizzaViewModel(name: 'Pizza 1', description: 'This pizza is very tasty', imgPath: 'assets/icons/vegetarian_pizza.png', price: 6.00),

    PizzaViewModel(name: 'Pizza 2', description: 'This pizza is very delicious', imgPath: 'assets/icons/margherita_pizza.png',price:7.00 ),

    PizzaViewModel(name: 'Pizza 3', description: 'This pizza is very amazing', imgPath: 'assets/icons/onion_and_paneer_pizza.png',price: 15.0),

    PizzaViewModel(name: 'Pizza 2', description: 'This pizza is very delicious', imgPath: 'assets/icons/margherita_pizza.png',price:7.00 ),
  ];

  int selectedPizza=1;
  PizzaCubit() : super(PizzaChangeState(rightSide: false));


}
