import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_delivery/common/app_fonts.dart';
import 'package:pizza_delivery/common/swipe_detector.dart';
import 'package:pizza_delivery/constant/colors.dart';
import 'package:pizza_delivery/cubit/pizza_cubit.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            _buildTopTitle(),
            _buildPizza(),
            Container(
              height: 50.0,
              width: 180.0,
              margin: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 174,
                child: StatefulBuilder(builder: (context, setStateForSize) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Row(
                        children: [
                          SizeButton(
                            onTap: () {
                              if (pizzaCubit.pizzaSize != PizzaSize.small) {
                                final old = pizzaCubit.pizzaSize;
                                pizzaCubit.pizzaSize = PizzaSize.small;
                                setStateForSize(() {});
                                count++;
                                pizzaCubit.emit(PizzaChangeSizeState(old));
                              }
                            },
                            text: 'S',
                            isSelected: pizzaCubit.pizzaSize == PizzaSize.small,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          SizeButton(
                              onTap: () {
                                if (pizzaCubit.pizzaSize != PizzaSize.medium) {
                                  final old = pizzaCubit.pizzaSize;
                                  pizzaCubit.pizzaSize = PizzaSize.medium;
                                  setStateForSize(() {});
                                  count++;
                                  pizzaCubit.emit(PizzaChangeSizeState(old));
                                }
                              },
                              text: 'M',
                              isSelected:
                                  pizzaCubit.pizzaSize == PizzaSize.medium),
                          const SizedBox(
                            width: 15,
                          ),
                          SizeButton(
                              onTap: () {
                                if (pizzaCubit.pizzaSize != PizzaSize.large) {
                                  final old = pizzaCubit.pizzaSize;
                                  pizzaCubit.pizzaSize = PizzaSize.large;
                                  setStateForSize(() {});
                                  count++;
                                  pizzaCubit.emit(PizzaChangeSizeState(old));
                                }
                              },
                              text: 'L',
                              isSelected:
                                  pizzaCubit.pizzaSize == PizzaSize.large),
                        ],
                      ),
                      AnimatedPositioned(
                          child: CircleAvatar(
                            radius: 24,
                            child: Text(
                              pizzaCubit.pizzaSize == PizzaSize.large
                                  ? 'L'
                                  : (pizzaCubit.pizzaSize == PizzaSize.medium
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
            const SizedBox(height: 10,),
            _toppingsCounter(),
            const SizedBox(height: 10,),
            const Expanded(child: PizzaToppingListView()),
            _addToCartButton()
          ],
        ),
      ),
    );
  }

  // Widget _sizeCircle() {
  //   return isThirdButtonSelected
  //       ? SlideTransition(
  //     position: _largeOffsetAnimation,
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 5.0),
  //       child: Container(
  //         decoration: const BoxDecoration(
  //           shape: BoxShape.circle,
  //           boxShadow: <BoxShadow>[
  //             BoxShadow(
  //               blurRadius: 15.0,
  //               spreadRadius: -5.0,
  //               color: Colors.black38,
  //             )
  //           ],
  //         ),
  //         child: const CircleAvatar(
  //           backgroundColor: AppColors.orange,
  //         ),
  //       ),
  //     ),
  //   )
  //       : SlideTransition(
  //     position: _offsetAnimation,
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 5.0),
  //       child: Container(
  //         decoration: const BoxDecoration(
  //           shape: BoxShape.circle,
  //           boxShadow: <BoxShadow>[
  //             BoxShadow(
  //               blurRadius: 15.0,
  //               spreadRadius: -5.0,
  //               color: Colors.black38,
  //             )
  //           ],
  //         ),
  //         child: const CircleAvatar(
  //           backgroundColor: AppColors.orange,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _sizeLabels() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         GestureDetector(
  //           onTap: () async {
  //             await _largeCircleController.reverse();
  //             _circleController.reverse();
  //             setState(() {
  //               isMediumSize = false;
  //               isLargeSize = false;
  //               isSmallSize = true;
  //             });
  //             if (!isFirstButtonSelected) {
  //               setState(() {
  //                 isThirdButtonSelected = false;
  //                 isSecondButtonSelected = false;
  //                 isFirstButtonSelected = true;
  //               });
  //             }
  //           },
  //           child: Text(
  //             'S',
  //             style: GoogleFonts.playfairDisplay(fontSize: 18.0),
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () async {
  //             await _circleController.forward();
  //             await _largeCircleController.reverse();
  //             setState(() {
  //               isSmallSize = false;
  //               isLargeSize = false;
  //               isMediumSize = true;
  //             });
  //             if (!isSecondButtonSelected) {
  //               setState(() {
  //                 isFirstButtonSelected = false;
  //                 isThirdButtonSelected = false;
  //                 isSecondButtonSelected = true;
  //               });
  //             }
  //           },
  //           child: Text(
  //             'M',
  //             style: GoogleFonts.playfairDisplay(fontSize: 18.0),
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () async {
  //             await _circleController.forward();
  //             _largeCircleController.forward();
  //             setState(() {
  //               isSmallSize = false;
  //               isMediumSize = false;
  //               isLargeSize = true;
  //             });
  //             if (!isThirdButtonSelected) {
  //               setState(() {
  //                 isFirstButtonSelected = false;
  //                 isSecondButtonSelected = false;
  //                 isThirdButtonSelected = true;
  //               });
  //             }
  //           },
  //           child: Text(
  //             'L',
  //             style: GoogleFonts.playfairDisplay(fontSize: 18.0),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPizzaNameAndDesc() {
    return BlocBuilder<PizzaCubit, PizzaState>(
      bloc: pizzaCubit,
      buildWhen: (prev,current){
        if(current.runtimeType == PizzaChangeState||current.runtimeType == PizzaChangedState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        final rightSide=state.runtimeType == PizzaChangeState?(state as PizzaChangeState).rightSide:null;
        return TweenAnimationBuilder(
          key: ValueKey(count),
          tween: Tween<double>(begin: 0,end: 1),
          builder: (context, double value,child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform(
                  transform: Matrix4.identity() .. rotateX(-(1-value)*pi/2),
                  child: Opacity(
                    opacity: rightSide!=null?1-value:1,
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
                          pizzaCubit.pizzaList[pizzaCubit.selectedPizza].description,
                          style: AppFonts.pizzaDescriptionFont,
                        ),
                      ],
                    ),
                  ),
                ),
                if(rightSide!=null)
                Transform(
                  transform: Matrix4.identity() .. rotateX((1-value)*pi/2),
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          pizzaCubit.pizzaList[pizzaCubit.selectedPizza+(rightSide?-1:1)].name,
                          style: AppFonts.pizzaTitleFont,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          pizzaCubit.pizzaList[pizzaCubit.selectedPizza+(rightSide?-1:1)].description,
                          style: AppFonts.pizzaDescriptionFont,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }, duration: const Duration(milliseconds: 600),
        );
      },
    );
  }
  Widget _toppingsCounter() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        '0/3',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
  Widget _buildTopTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(child: _buildPizzaNameAndDesc()),
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
    );
  }

  Widget _buildPizza() {
    final deviceWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<PizzaCubit, PizzaState>(
      bloc: pizzaCubit,
      builder: (context, state) {
        final pizzaSize = getPizzaSize(pizzaCubit.pizzaSize);
        final prevPizzaSize = pizzaSize - 50;
        bool? rightSwipe = (state.runtimeType == PizzaChangeState)
            ? (state as PizzaChangeState).rightSide
            : null;
        late final double? oldPizzaSize;
        if (state.runtimeType == PizzaChangeSizeState) {
          oldPizzaSize = getPizzaSize(pizzaCubit.pizzaSize);
        }
        else{
          oldPizzaSize = null;
        }

        return SwipeDetector(
          onSwipe: (rightSwipe) {
            if (state.runtimeType != PizzaChangeState) {
              if (rightSwipe) {
                if (pizzaCubit.selectedPizza > 0) {
                  count--;
                  pizzaCubit.emit(PizzaChangeState(rightSide: rightSwipe));
                }
              } else {
                if (pizzaCubit.pizzaList.length - 1 >
                    pizzaCubit.selectedPizza) {
                  count++;
                  pizzaCubit.emit(PizzaChangeState(rightSide: rightSwipe));
                }
              }
            }

            // print('SWIPE ${rightSwipe?'RIGHT':'LEFT'}');
          },
          child: TweenAnimationBuilder(
            key: ValueKey(count),
            tween: Tween<double>(begin: 0, end: 1),
            duration:
                rightSwipe != null || state.runtimeType == PizzaChangeSizeState
                    ? const Duration(milliseconds: 600)
                    : const Duration(milliseconds: 0),
            curve: Curves.linearToEaseOut,
            onEnd: () {
              if (rightSwipe != null) {
                if (rightSwipe) {
                  pizzaCubit.selectedPizza--;
                } else {
                  pizzaCubit.selectedPizza++;
                }
                pizzaCubit.emit(PizzaChangedState());
              }
            },
            builder: (context, double value, child) {
              final pizzaChangedSize = rightSwipe != null
                  ? (value < 0.4)
                      ? (pizzaSize -
                          ((value + 0.7) * (pizzaSize - prevPizzaSize)))
                      : prevPizzaSize
                  : pizzaSize;
              final size2=(oldPizzaSize!=null?(oldPizzaSize + value*(pizzaSize-oldPizzaSize)):pizzaChangedSize);
              final plateSize=(oldPizzaSize!=null?(oldPizzaSize +30+ value*(pizzaSize-oldPizzaSize)):(pizzaSize+30));
              return Column(
                children: [
                  SizedBox(
                    height: 350,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: PhysicalModel(
                            shadowColor: Colors.grey,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(plateSize / 2),
                            color: Colors.brown.shade800,
                            elevation: 3,
                            child: Image.asset(
                              'assets/icons/pizza_plate.png',
                              width: plateSize,
                              height: plateSize,
                              fit: BoxFit.fitWidth,
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
                            angle: pi * ((value - 0.2) > 0 ? value - 0.2 : 0),
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
                              angle: pi * ((value - 0.4) > 0 ? value - 0.2 : 0),
                              child: Image.asset(
                                pizzaCubit
                                    .pizzaList[pizzaCubit.selectedPizza +
                                        (rightSwipe ? -1 : 1)]
                                    .imgPath,
                                width: pizzaSize,
                                height: pizzaSize,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        Padding(
                          key: const ObjectKey('add_remove'),
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _circularButton(Icons.remove),
                              const Spacer(),
                              _circularButton(Icons.add),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPrice(value, rightSwipe)
                ],
              );
            },
          ),
        );
      },
    );
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
        return 230;
      case PizzaSize.small:
        return 200;
      case PizzaSize.large:
        return 260;
    }
  }

  Widget _buildPrice(double value, bool? rightSwipe) {
    final interpolate = rightSwipe != null
        ? (pizzaCubit.pizzaList[pizzaCubit.selectedPizza].price +
            (pizzaCubit
                        .pizzaList[
                            pizzaCubit.selectedPizza + (rightSwipe ? -1 : 1)]
                        .price -
                    pizzaCubit.pizzaList[pizzaCubit.selectedPizza].price) *
                value)
        : pizzaCubit.pizzaList[pizzaCubit.selectedPizza].price;

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
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.0,fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class SizeButton extends StatelessWidget {
  const SizeButton(
      {Key? key,
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
class PizzaToppingListView extends StatelessWidget{
  static const  List<String> listItem = [
    'assets/images/toppings/green_chillies_thumb.png',
    'assets/images/toppings/green_peppers_thumb.png',
    'assets/images/toppings/halloumi_thumb.png',
    'assets/images/toppings/mushrooms_thumb.png',
    'assets/images/toppings/olives_thumb.png',
    'assets/images/toppings/onions_thumb.png',
    'assets/images/toppings/pineapples_thumb.png',
    'assets/images/toppings/sweetcorn_thumb.png',
    'assets/images/toppings/tomatos_thumb.png',
  ];

  const PizzaToppingListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: -1,
      child: ListWheelScrollView(
          itemExtent: 100,
          offAxisFraction: -1.2,
          children: listItem.map((e) => Image.asset(e,width: 50,height: 50,fit: BoxFit.fill,)).toList()),
    );
  }

}