part of 'pizza_cubit.dart';

@immutable
abstract class PizzaState {}

class PizzaInitial extends PizzaState {}

class PizzaChangeState extends PizzaState {
  PizzaChangeState({required this.rightSide});
  final bool rightSide;
}

class PizzaToppingChangeState extends PizzaState{
  PizzaToppingChangeState();
}
class PizzaChangedState extends PizzaState {
  PizzaChangedState();
}

class PizzaChangeSizeState extends PizzaState {
  PizzaChangeSizeState(this.oldSize);
  final PizzaSize oldSize;
}




