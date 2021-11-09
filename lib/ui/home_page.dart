import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_delivery/common/app_fonts.dart';
import 'package:pizza_delivery/common/swipe_detector.dart';
import 'package:pizza_delivery/common/time_duration.dart';
import 'package:pizza_delivery/constant/colors.dart';
import 'package:pizza_delivery/cubit/pizza_cubit.dart';
import 'package:pizza_delivery/ui/custom_painters.dart';
import 'package:pizza_delivery/ui/pizza_topping.dart';
import 'package:pizza_delivery/viewmodel/pizza_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PizzaCubit pizzaCubit = PizzaCubit();
  late final AnimationController animationController;
  int count = 0;

  int? pizzaIndex;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => pizzaCubit,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildTopTitle(),
                  _buildPizza(),
                  const Spacer(),
                  SizedBox(
                    height: 50.0,
                    width: 180.0,
                    child: SizedBox(
                      width: 174,
                      child:
                      StatefulBuilder(builder: (context, setStateForSize) {
                        return Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Row(
                              children: [
                                SizeButton(
                                  onTap: () {
                                    if (pizzaCubit.pizzaSize !=
                                        PizzaSize.small) {
                                      final old = pizzaCubit.pizzaSize;
                                      pizzaCubit.pizzaSize = PizzaSize.small;
                                      setStateForSize(() {});
                                      count++;
                                      pizzaCubit.changePizzaSize(old);
                                    }
                                  },
                                  text: 'S',
                                  isSelected:
                                  pizzaCubit.pizzaSize == PizzaSize.small,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                SizeButton(
                                    onTap: () {
                                      if (pizzaCubit.pizzaSize !=
                                          PizzaSize.medium) {
                                        final old = pizzaCubit.pizzaSize;
                                        pizzaCubit.pizzaSize = PizzaSize.medium;
                                        setStateForSize(() {});
                                        count++;
                                        pizzaCubit.changePizzaSize(old);
                                      }
                                    },
                                    text: 'M',
                                    isSelected: pizzaCubit.pizzaSize ==
                                        PizzaSize.medium),
                                const SizedBox(
                                  width: 15,
                                ),
                                SizeButton(
                                    onTap: () {
                                      if (pizzaCubit.pizzaSize !=
                                          PizzaSize.large) {
                                        final old = pizzaCubit.pizzaSize;
                                        pizzaCubit.pizzaSize = PizzaSize.large;
                                        setStateForSize(() {});
                                        count++;
                                        pizzaCubit.changePizzaSize(old);
                                      }
                                    },
                                    text: 'L',
                                    isSelected: pizzaCubit.pizzaSize ==
                                        PizzaSize.large),
                              ],
                            ),
                            AnimatedPositioned(
                                child: CircleAvatar(
                                  radius: 24,
                                  child: Text(
                                    pizzaCubit.pizzaSize == PizzaSize.large
                                        ? 'L'
                                        : (pizzaCubit.pizzaSize ==
                                        PizzaSize.medium
                                        ? 'M'
                                        : 'S'),
                                    style: GoogleFonts.playfairDisplay(
                                        fontSize: 18.0, color: AppColors.brown),
                                  ),
                                  backgroundColor: AppColors.orange,
                                ),
                                left: pizzaCubit.pizzaSize == PizzaSize.small
                                    ? 0
                                    : (pizzaCubit.pizzaSize == PizzaSize.medium
                                    ? 63
                                    : 126),
                                duration: const Duration(milliseconds: 200)),
                          ],
                        );
                      }),
                    ),
                  ),
                  const Spacer(),
                  BlocConsumer<PizzaCubit, PizzaState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                            child: _toppingsCounter(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 70,
                            child: PizzaToppingListView(),
                          ),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 100,
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: CurveLinePainter(
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width),
                        ),
                        Center(child: _addToCartButton()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              _buildToppingView(),
              Padding(
                key: const ObjectKey('add'),
                padding:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 230),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: _circularButton(Icons.remove),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  key: const ObjectKey('remove'),
                  padding: const EdgeInsets.only(right: 60.0, top: 230),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: _circularButton(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPizzaNameAndDesc() {
    return BlocBuilder<PizzaCubit, PizzaState>(
      bloc: pizzaCubit,
      buildWhen: (prev, current) {
        if (current.runtimeType == PizzaChangeState ||
            current.runtimeType == PizzaChangedState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        final rightSide = state.runtimeType == PizzaChangeState
            ? (state as PizzaChangeState).rightSide
            : null;
        return TweenAnimationBuilder(
          key: ValueKey(count),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform(
                  transform: Matrix4.identity()
                    ..rotateX(-(1 - value) * pi / 2),
                  child: Opacity(
                    opacity: rightSide != null ? 1 - value : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          pizzaCubit.pizzaList[pizzaCubit.selectedPizza].name,
                          style: AppFonts.pizzaTitleFont,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          pizzaCubit
                              .pizzaList[pizzaCubit.selectedPizza].description,
                          style: AppFonts.pizzaDescriptionFont,
                        ),
                      ],
                    ),
                  ),
                ),
                if (rightSide != null)
                  Transform(
                    transform: Matrix4.identity()
                      ..rotateX((1 - value) * pi / 2),
                    child: Opacity(
                      opacity: value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            pizzaCubit
                                .pizzaList[pizzaIndex!]
                                .name,
                            style: AppFonts.pizzaTitleFont,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            pizzaCubit
                                .pizzaList[pizzaIndex!]
                                .description,
                            style: AppFonts.pizzaDescriptionFont,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
          duration:pizzaChangingDuration,
        );
      },
    );
  }

  Widget _toppingsCounter() {
    return Text(
      '${pizzaCubit.toppings.length}/${pizzaCubit.toppingList.length}',
      style: const TextStyle(
        color: Colors.grey,
      ),
    );
  }

  Widget _buildTopTitle() {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: () {},
            child: Image.asset(
              'assets/icons/left-arrow.png',
              height: 26.0,
              width: 26.0,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(child: _buildPizzaNameAndDesc(),),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/icons/heart.png',
              height: 25.0,
              width: 25.0,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPizza() {
    final deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    return BlocBuilder<PizzaCubit, PizzaState>(
      bloc: pizzaCubit,
      buildWhen: (prev, current) {
        // if (current.runtimeType == PizzaChangeState ||
        //     current.runtimeType == PizzaChangedState ||
        //     current.runtimeType == PizzaChangeSizeState) {
        return true;
        // }
        // return false;
      },
      builder: (context, state) {
        if (state.runtimeType == PizzaToppingChangeState) {
          count++;
        }
        final pizzaSize = getPizzaSize(pizzaCubit.pizzaSize);
        final prevPizzaSize = pizzaSize - 50;
        bool? rightSwipe = (state.runtimeType == PizzaChangeState)
            ? (state as PizzaChangeState).rightSide
            : null;
        late final double? oldPizzaSize;
        if (state.runtimeType == PizzaChangeSizeState) {
          oldPizzaSize = getPizzaSize((state as PizzaChangeSizeState).oldSize);
        } else {
          oldPizzaSize = null;
        }

        return SwipeDetector(
          // swipeConfig: const SimpleSwipeConfig(horizontalThreshold: 2),
          // onHorizontalSwipe: (direction) {
          //   onSwipe(direction == SwipeDirection.right);
          // },
          onSwipe: onSwipe,
          child: TweenAnimationBuilder(
            key: ValueKey(count),
            tween: Tween<double>(begin: 0, end: 1),
            duration: getTweenAnimationDuration(state, rightSwipe),
            curve: rightSwipe != null
                ? Curves.linearToEaseOut
                : Curves.easeInOutBack,
            onEnd: () {
              if (rightSwipe != null) {
                if (pizzaCubit.selectedPizza != pizzaIndex) {
                  pizzaCubit.selectedPizza = pizzaIndex!;

                  pizzaCubit.emit(PizzaChangedState());
                }
              }
            },
            builder: (context, double value, child) {
              final pizzaChangedSize = rightSwipe != null
                  ? (value < 0.4)
                  ? (pizzaSize -
                  ((value + 0.7) * (pizzaSize - prevPizzaSize)))
                  : prevPizzaSize
                  : pizzaSize;
              final size2 = (oldPizzaSize != null
                  ? (oldPizzaSize +
                  (value < 0.4
                      ? 0
                      : (value - 0.4) *
                      (value - 0.4) *
                      (pizzaSize / (pizzaSize * 0.36))) *
                      (pizzaSize - oldPizzaSize))
                  : pizzaChangedSize);
              final plateSize = (oldPizzaSize != null
                  ? (oldPizzaSize +
                  30 +
                  (value > 0.6 ? value * value : value) *
                      (pizzaSize - oldPizzaSize))
                  : (pizzaSize + 30));
              final saladCurrentAngle = (pizzaCubit.selectedPizza * pi / 6);
              return Column(
                children: [
                  SizedBox(
                    height: 350,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: rightSwipe != null
                              ? (saladCurrentAngle +
                              ((pizzaIndex! * pi / 6) - saladCurrentAngle) *
                                  (2 * value * value - value))
                              : saladCurrentAngle,
                          child: Image.asset(
                            'assets/images/circle_salad.png',
                            width: plateSize + 50,
                            fit: BoxFit.fitWidth,
                            filterQuality: ui.FilterQuality.low,
                          ),
                        ),
                        Transform.rotate(
                          angle: rightSwipe != null
                              ? pi / 6 * (1 - value) * sin(value * 3 * pi)
                              : 0,
                          //((2*value*value*value)+((1-value)*(1-value))-value)*pi/3
                          child: PhysicalModel(
                            shadowColor: Colors.grey,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(plateSize / 2),
                            color: Colors.brown.shade800,
                            elevation: 10,
                            child: Image.asset(
                              'assets/images/wooden_plate.png',
                              width: plateSize,
                              height: plateSize,
                              fit: BoxFit.fitWidth,
                              filterQuality: ui.FilterQuality.low,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: rightSwipe != null
                              ? Offset(
                              value *
                                  (rightSwipe
                                      ? (deviceWidth / 2) +
                                      (prevPizzaSize / 2)
                                      : -((deviceWidth / 2) +
                                      (prevPizzaSize / 2))),
                              0)
                              : const Offset(0, 0),
                          child: Transform.rotate(
                            angle: rightSwipe != null
                                ? (rightSwipe ? 1 : -1) *
                                pi *
                                ((value - 0.4) > 0 ? value - 0.4 : 0)
                                : 0.6 * pi,
                            child: Image.asset(
                              pizzaCubit
                                  .pizzaList[pizzaCubit.selectedPizza].imgPath,
                              width: size2,
                              height: size2,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        if (rightSwipe != null)
                          Transform.translate(
                            offset: Offset(
                                (1 - value) *
                                    (rightSwipe
                                        ? -((deviceWidth / 2) + (pizzaSize / 2))
                                        : (deviceWidth / 2) + (pizzaSize / 2)),
                                0),
                            child: Transform.rotate(
                              angle: pi * ((value - 0.4) > 0 ? value - 0.4 : 0),
                              child: Image.asset(
                                pizzaCubit
                                    .pizzaList[pizzaIndex!]
                                    .imgPath,
                                width: pizzaSize,
                                height: pizzaSize,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildPrice(
                      value,
                      rightSwipe,
                      state.runtimeType == PizzaChangeSizeState
                          ? (state as PizzaChangeSizeState).oldSize
                          : null,
                      state),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void onSwipe(bool isRightSwipe) {
    if (pizzaIndex != null && pizzaIndex != pizzaCubit.selectedPizza) {
      pizzaCubit.emit(PizzaChangedState());
      pizzaCubit.selectedPizza = pizzaIndex!;
    }
    if (isRightSwipe) {
      if (pizzaCubit.selectedPizza > 0) {
        count--;
        pizzaIndex = pizzaCubit.selectedPizza - 1;
      }
      else {
        count = pizzaCubit.pizzaList.length - 1;
        pizzaIndex = pizzaCubit.pizzaList.length - 1;
      }
      pizzaCubit.changePizzaState(isRightSwipe);
    } else {
      if (pizzaCubit.pizzaList.length - 1 > pizzaCubit.selectedPizza) {
        count++;
        pizzaIndex = pizzaCubit.selectedPizza + 1;
      }
      else {
        count = 0;
        pizzaIndex = 0;
      }
      pizzaCubit.changePizzaState(isRightSwipe);
    }
  }

  Widget _circularButton(IconData icon) {
    return Container(
      height: 35.0,
      width: 35.0,
      decoration: const BoxDecoration(
        color: AppColors.bluishWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 25.0,
            spreadRadius: -5.0,
            color: Colors.black45,
          )
        ],
        shape: BoxShape.circle,
      ),
      child: Icon(icon),
    );
  }

  double getPizzaSize(PizzaSize size) {
    switch (size) {
      case PizzaSize.medium:
        return 215;
      case PizzaSize.small:
        return 180;
      case PizzaSize.large:
        return 250;
    }
  }

  double getPizzaPrice(PizzaSize size) {
    switch (size) {
      case PizzaSize.medium:
        return 0;
      case PizzaSize.small:
        return -3;
      case PizzaSize.large:
        return 3;
    }
  }

  Widget _buildPrice(double value, bool? rightSwipe, PizzaSize? oldPizzaSize,
      PizzaState state) {
    double oldToppingPrice = 0.0,
        newToppingPrice = 0.0;
    if (rightSwipe == null) {
      for (final topping in pizzaCubit.toppingList) {
        if (topping.selected) {
          oldToppingPrice += topping.price;
        }
      }
    }
    newToppingPrice = oldToppingPrice;
    if (state.runtimeType == PizzaToppingChangeState) {
      if ((state as PizzaToppingChangeState).added) {
        oldToppingPrice -= state.topping.price;
      } else {
        newToppingPrice -= state.topping.price;
      }
    }
    final oldPrice = pizzaCubit.pizzaList[pizzaCubit.selectedPizza].price +
        (oldPizzaSize != null ? getPizzaPrice(oldPizzaSize) : 0) +
        oldToppingPrice;

    final changedPizzaPrice = (rightSwipe != null
        ? pizzaCubit
        .pizzaList[pizzaIndex!]
        .price
        : (pizzaCubit.pizzaList[pizzaCubit.selectedPizza].price)) +
        (getPizzaPrice(pizzaCubit.pizzaSize)) +
        newToppingPrice;

    final interpolate = oldPrice != changedPizzaPrice
        ? (oldPrice + (changedPizzaPrice - oldPrice) * value)
        : oldPrice;

    return Text(
      '\$${interpolate.toStringAsFixed(2)}',
      style: AppFonts.pizzaPriceFont,
    );
  }

  Widget _addToCartButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: Container(
        height: 50.0,
        width: 170.0,
        decoration: const BoxDecoration(
          color: AppColors.brown,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 25.0,
              spreadRadius: -5.0,
              color: Colors.black26,
              offset: Offset(0.0, 10.0),
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 20.0),
            Text(
              'Add To Cart',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToppingView() {
    return BlocBuilder<PizzaCubit, PizzaState>(
      bloc: pizzaCubit,
      buildWhen: (prev, current) {
        if (current.runtimeType == PizzaToppingChangeState ||
            pizzaCubit.toppings.isEmpty) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Stack(
          children: [
            for (Topping topping in pizzaCubit.toppings)
              FutureBuilder<ui.Image>(
                  future: Future(() async {
                    final ByteData data =
                    await rootBundle.load(topping.unitImg);
                    final Completer<ui.Image> completer = Completer();
                    ui.decodeImageFromList(Uint8List.view(data.buffer),
                            (ui.Image img) {
                          return completer.complete(img);
                        });
                    return completer.future;
                  }),
                  key: ValueKey(topping.img),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TweenAnimationBuilder(
                        // key: GlobalKey(),
                        key: ValueKey(topping.img),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return CustomPaint(
                            painter: TopperPainter(
                              deviceWidth:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width
                                  .toInt(),
                              deviceHeight:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height
                                  .toInt(),
                              img: snapshot.data!,
                              value: value,
                              positions: topping.positions,
                              pizzaSize: getPizzaSize(pizzaCubit.pizzaSize),
                            ),
                          );
                        },
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.decelerate,
                      );
                    }
                    return Container();
                  })
          ],
        );
      },
    );
  }

  Duration getTweenAnimationDuration(PizzaState state, bool? rightSwipe) {
    if (rightSwipe != null) {
      return pizzaChangingDuration;
    }
    switch (state.runtimeType) {
      case PizzaChangeSizeState:
        return const Duration(milliseconds: 800);
      case PizzaToppingChangeState:
        return const Duration(milliseconds: 500);
      default:
        return const Duration(seconds: 0);
    }
  }
}

class SizeButton extends StatelessWidget {
  const SizeButton({Key? key,
    required this.onTap,
    required this.text,
    required this.isSelected})
      : super(key: key);
  final void Function() onTap;
  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: PhysicalModel(
        elevation: 2,
        color: Colors.white,
        shape: BoxShape.circle,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          child: Text(
            text,
            style: GoogleFonts.playfairDisplay(
                fontSize: 18.0, color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
