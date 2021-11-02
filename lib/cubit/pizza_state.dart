part of 'pizza_cubit.dart';

@immutable
abstract class PizzaState {}

class PizzaInitial extends PizzaState {}

class PizzaChangeState extends PizzaState {
  PizzaChangeState({required this.rightSide});
  final bool rightSide;
}


class PizzaChangedState extends PizzaState {
  PizzaChangedState();
}


