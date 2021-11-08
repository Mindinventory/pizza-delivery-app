part of 'pizza_cubit.dart';

@immutable
abstract class PizzaState {}

class PizzaInitial extends PizzaState {}

class PizzaChangeState extends PizzaState {
  PizzaChangeState({required this.rightSide});
  final bool rightSide;
}

class PizzaToppingChangeState extends PizzaState{
  PizzaToppingChangeState(this.topping, this.added);
  final ToppingItemModel topping;
  final bool added;
}
class PizzaChangedState extends PizzaState {
  PizzaChangedState();
}

class PizzaChangeSizeState extends PizzaState {
  PizzaChangeSizeState(this.oldSize);
  final PizzaSize oldSize;
}




