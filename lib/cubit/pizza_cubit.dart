import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pizza_delivery/viewmodel/pizza_viewmodel.dart';

part 'pizza_state.dart';

class PizzaCubit extends Cubit<PizzaState> {
  final List<PizzaViewModel> pizzaList=[
    PizzaViewModel(name: 'Pizza 1', description: 'This pizza is very tasty', imgPath:   'assets/images/pizza1.png', price: 6.00),

    PizzaViewModel(name: 'Pizza 2', description: 'This pizza is very delicious', imgPath:'assets/images/pizza2.png',price:7.00 ),

    PizzaViewModel(name: 'Pizza 3', description: 'This pizza is very amazing', imgPath: 'assets/images/pizza3.png',price: 15.0),

    PizzaViewModel(name: 'Pizza 4', description: 'This pizza is very delicious', imgPath: 'assets/images/pizza4.png',price:5.00 ),
    PizzaViewModel(name: 'Pizza 5', description: 'This pizza is very delicious', imgPath: 'assets/images/pizza5.png',price:20.00 ),
    PizzaViewModel(name: 'Pizza 6', description: 'This pizza is very delicious', imgPath: 'assets/images/pizza6.png',price:13.00 ),

  ];
  PizzaSize pizzaSize=PizzaSize.medium;
  int selectedPizza=1;
  PizzaCubit() : super(PizzaInitial());


}
