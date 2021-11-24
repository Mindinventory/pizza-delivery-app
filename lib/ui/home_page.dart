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
import 'package:pizza_delivery/core/res/app_assets.dart';
import 'package:pizza_delivery/core/res/app_strings.dart';
import 'package:pizza_delivery/cubit/pizza_cubit.dart';
import 'package:pizza_delivery/extensions/context_extension.dart';
import 'package:pizza_delivery/extensions/dimension_extension.dart';
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
  final PizzaCubit _pizzaCubit = PizzaCubit();

  int _count = -1, _saladCount=0;
  int? _pizzaIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _mainBlocProvider(),
      ),
    );
  }

  Widget _mainBlocProvider() {
    return BlocProvider(
      create: (context) => _pizzaCubit,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            Column(
              children: [
                _TopTitle(
                  pizzaCubit: _pizzaCubit,
                  count: _count,
                  pizzaIndex: _pizzaIndex ?? 0,
                ),
                const Spacer(),
                _buildPizza(),
                const Spacer(),
                StatefulBuilder(
                    builder: (context, setStateForSize) {
                      return Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SizeButton(
                                onTap: () {
                                  if (_pizzaCubit.pizzaSize != PizzaSize.small) {
                                    final old = _pizzaCubit.pizzaSize;
                                    _pizzaCubit.pizzaSize = PizzaSize.small;
                                    setStateForSize(() {});
                                    _count++;
                                    _pizzaCubit.changePizzaSize(old);
                                  }
                                },
                                text: AppStrings.sizeS,
                                isSelected: _pizzaCubit.pizzaSize == PizzaSize.small,
                              ),
                              SizedBox(width: 15.toSize(context)),
                              _SizeButton(
                                onTap: () {
                                  if (_pizzaCubit.pizzaSize != PizzaSize.medium) {
                                    final old = _pizzaCubit.pizzaSize;
                                    _pizzaCubit.pizzaSize = PizzaSize.medium;
                                    setStateForSize(() {});
                                    _count++;
                                    _pizzaCubit.changePizzaSize(old);
                                  }
                                },
                                text: AppStrings.sizeM,
                                isSelected: _pizzaCubit.pizzaSize == PizzaSize.medium,
                              ),
                              SizedBox(width: 15.toSize(context)),
                              _SizeButton(
                                onTap: () {
                                  if (_pizzaCubit.pizzaSize != PizzaSize.large) {
                                    final old = _pizzaCubit.pizzaSize;
                                    _pizzaCubit.pizzaSize = PizzaSize.large;
                                    setStateForSize(() {});
                                    _count++;
                                    _pizzaCubit.changePizzaSize(old);
                                  }
                                },
                                text: AppStrings.sizeL,
                                isSelected: _pizzaCubit.pizzaSize == PizzaSize.large,
                              ),
                            ],
                          ),
                          AnimatedPositioned(
                            child: CircleAvatar(
                              radius: 24.toSize(context),
                              child: Text(
                                _pizzaCubit.pizzaSize.pizzaSize,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 18.0.toSize(context),
                                  color: AppColors.brown,
                                ),
                              ),
                              backgroundColor: AppColors.orange,
                            ),
                            left: _getLeftPadding(),
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      );
                    },
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.toSize(context),
                      child: _ToppingsCounter(pizzaCubit: _pizzaCubit,),
                    ),
                    SizedBox(height: 10.toSize(context)),
                    PizzaToppingListView(),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: context.width,
                  height: 100.toSize(context),
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: CurveLinePainter(
                          context.width,
                        ),
                      ),
                      const Center(child: _AddToCart()),
                    ],
                  ),
                ),
                SizedBox(height: 10.toSize(context)),
              ],
            ),
            _ToppingView(pizzaCubit: _pizzaCubit,),
            Padding(
              key: const ObjectKey('add'),
              padding: EdgeInsets.only(left: 60.0.toSize(context), top: 230.toSize(context)),
              child: SizedBox(
                height: 30.toSize(context),
                width: 30.toSize(context),
                child: const _CircularButton(icon: Icons.remove),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                key: const ObjectKey('remove'),
                padding: EdgeInsets.only(right: 60.0.toSize(context), top: 230.toSize(context)),
                child: SizedBox(
                  height: 30.toSize(context),
                  width: 30.toSize(context),
                  child: const _CircularButton(icon: Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPizza() {
    final deviceWidth = context.width;

    return BlocBuilder<PizzaCubit, PizzaState>(
      bloc: _pizzaCubit,
      buildWhen: (prev, current) {
        return true;
      },
      builder: (context, state) {
        if (state.runtimeType == PizzaToppingChangeState) {
          _count++;
        }
        final pizzaSize = _getPizzaSize(_pizzaCubit.pizzaSize, context);
        final prevPizzaSize = pizzaSize - 50.toSize(context);
        bool? rightSwipe = (state.runtimeType == PizzaChangeState)
            ? (state as PizzaChangeState).rightSide
            : null;
        late final double? oldPizzaSize;
        if (state.runtimeType == PizzaChangeSizeState) {
          oldPizzaSize = _getPizzaSize((state as PizzaChangeSizeState).oldSize, context);
        } else {
          oldPizzaSize = null;
        }

        return SwipeDetector(
          onSwipe: _onSwipe,
          child: TweenAnimationBuilder(
            key: ValueKey(_count),
            tween: Tween<double>(begin: 0, end: 1),
            duration: _getTweenAnimationDuration(state, rightSwipe),
            curve: rightSwipe != null
                ? Curves.linearToEaseOut
                : Curves.easeInOutBack,
            onEnd: () {
              if (rightSwipe != null) {
                if (_pizzaCubit.selectedPizza != _pizzaIndex) {
                  _pizzaCubit.selectedPizza = _pizzaIndex!;
                  _pizzaCubit.emit(PizzaChangedState());
                }
              }
            },
            builder: (context, double value, child) {
              final pizzaChangedSize = rightSwipe != null
                  ? (value < 0.4)
                      ? (pizzaSize - ((value + 0.7) * (pizzaSize - prevPizzaSize)))
                      : prevPizzaSize
                  : pizzaSize;
              final size2 = (oldPizzaSize != null
                  ? (oldPizzaSize + (value < 0.4
                     ? 0
                     : (value - 0.4) * (value - 0.4) * (pizzaSize / (pizzaSize * 0.36))) * (pizzaSize - oldPizzaSize))
                  : pizzaChangedSize);
              final plateSize = (oldPizzaSize != null
                  ? (oldPizzaSize + 30 + (value > 0.6 ? value * value : value) * (pizzaSize - oldPizzaSize))
                  : (pizzaSize + 30));
              final double? saladCurrentAngle = (rightSwipe != null)
                  ? ((rightSwipe ? (_saladCount + 1) : (_saladCount - 1)) * pi / 6)
                  : null;
              late final double? saladNewAngle = _saladCount * pi / 6;

              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: saladCurrentAngle != null
                            ? (saladCurrentAngle + (saladNewAngle! - saladCurrentAngle) * (value * value))
                            : saladNewAngle!,
                        child: Image.asset(
                          AppAssets.circleSalad,
                          width: plateSize + 50,
                          fit: BoxFit.fitWidth,
                          filterQuality: ui.FilterQuality.low,
                        ),
                      ),
                      Transform.rotate(
                        angle: rightSwipe != null
                            ? pi / 6 * (1 - value) * sin(value * 3 * pi)
                            : 0,
                        child: PhysicalModel(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(plateSize / 2),
                          color: Colors.transparent,
                          elevation: 10,
                          child: Image.asset(
                            AppAssets.woodenPlate,
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
                                value * (rightSwipe
                                        ? (deviceWidth / 2) + (prevPizzaSize / 2)
                                        : -((deviceWidth / 2) + (prevPizzaSize / 2))),
                                0,
                              )
                            : const Offset(0, 0),
                        child: Transform.rotate(
                          angle: rightSwipe != null
                              ? (rightSwipe ? 1 : -1) *
                                  pi *
                                  ((value - 0.4) > 0 ? value - 0.4 : 0)
                              : 0.6 * pi,
                          child: Image.asset(
                            _pizzaCubit.pizzaList[_pizzaCubit.selectedPizza].imgPath,
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
                              0,
                            ),
                            child: Transform.rotate(
                              angle: pi * ((value - 0.4) > 0 ? value - 0.4 : 0),
                              child: Image.asset(
                                _pizzaCubit.pizzaList[_pizzaIndex!].imgPath,
                                width: pizzaSize,
                                height: pizzaSize,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  _buildPrice(
                    value,
                    rightSwipe,
                    state.runtimeType == PizzaChangeSizeState
                        ? (state as PizzaChangeSizeState).oldSize
                        : null,
                    state,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _onSwipe(bool isRightSwipe) {
    if (_pizzaIndex != null && _pizzaIndex != _pizzaCubit.selectedPizza) {
      _pizzaCubit.emit(PizzaChangedState());
      _pizzaCubit.selectedPizza = _pizzaIndex!;
    }
    if (isRightSwipe) {
      if (_pizzaCubit.selectedPizza > 0) {
        _pizzaIndex = _pizzaCubit.selectedPizza - 1;
      } else {
        _pizzaIndex = _pizzaCubit.pizzaList.length - 1;
      }
      _count = _pizzaIndex!;
      _saladCount = _saladCount - 1;
      if (_saladCount < 0) {
        _saladCount = 11;
      }
      _pizzaCubit.changePizzaState(isRightSwipe);
    } else {
      if (_pizzaCubit.pizzaList.length - 1 > _pizzaCubit.selectedPizza) {
        _pizzaIndex = _pizzaCubit.selectedPizza + 1;
      } else {
        _pizzaIndex = 0;
      }
      _count = _pizzaIndex!;
      _saladCount = (_saladCount + 1) % 12;
      _pizzaCubit.changePizzaState(isRightSwipe);
    }
  }

  double _getPizzaPrice(PizzaSize size) {
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
      for (final topping in _pizzaCubit.toppingList) {
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
    final oldPrice = _pizzaCubit.pizzaList[_pizzaCubit.selectedPizza].price +
        (oldPizzaSize != null ? _getPizzaPrice(oldPizzaSize) : 0) + oldToppingPrice;

    final changedPizzaPrice = (rightSwipe != null
        ? _pizzaCubit.pizzaList[_pizzaIndex!].price
        : (_pizzaCubit.pizzaList[_pizzaCubit.selectedPizza].price)) +
        (_getPizzaPrice(_pizzaCubit.pizzaSize)) + newToppingPrice;

    final interpolate = oldPrice != changedPizzaPrice
        ? (oldPrice + (changedPizzaPrice - oldPrice) * value)
        : oldPrice;

    return Text(
      '\$${interpolate.toStringAsFixed(2)}',
      style: AppFonts.pizzaPriceFont,
    );
  }

  double _getLeftPadding() {

    double buttonSize = 24.toSize(context);
    double buttonPadding = 15.toSize(context);
    double screenPadding = (2.8).toSize(context);

    return _pizzaCubit.pizzaSize == PizzaSize.small
        ?  (context.width / 2) - buttonSize - (buttonPadding / 2) - screenPadding - (buttonSize + (buttonPadding + buttonSize))
        : (_pizzaCubit.pizzaSize == PizzaSize.medium
        ? (context.width / 2) - buttonSize - (buttonPadding / 2) - screenPadding
        : ((context.width / 2) - buttonSize - (buttonPadding / 2) - screenPadding) + (buttonSize + (buttonPadding + buttonSize)));
  }

  Duration _getTweenAnimationDuration(PizzaState state, bool? rightSwipe) {
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

class _TopTitle extends StatelessWidget {
  const _TopTitle({
    required this.pizzaCubit,
    required this.count,
    required this.pizzaIndex,
  });

  final PizzaCubit pizzaCubit;
  final int count;
  final int pizzaIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: () {},
          child: Image.asset(
            AppAssets.leftArrow,
            height: 25.0.toSize(context),
            width: 25.0.toSize(context),
          ),
        ),
        SizedBox(width: 15.toSize(context)),
        Expanded(
          child: _PizzaNameAndDesc(
            pizzaCubit: pizzaCubit,
            count: count,
            pizzaIndex: pizzaIndex,
          ),
        ),
        SizedBox(width: 15.toSize(context)),
        InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            AppAssets.heart,
            height: 25.0.toSize(context),
            width: 25.0.toSize(context),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}

class _PizzaNameAndDesc extends StatelessWidget {
  const _PizzaNameAndDesc({
    required this.pizzaCubit,
    required this.count,
    required this.pizzaIndex,
  });

  final PizzaCubit pizzaCubit;
  final int count;
  final int pizzaIndex;

  @override
  Widget build(BuildContext context) {
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
                  transform: Matrix4.identity()..rotateX(-(1 - value) * pi / 2),
                  child: Opacity(
                    opacity: rightSide != null ? 1 - value : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          pizzaCubit.pizzaList[pizzaCubit.selectedPizza].name,
                          style: AppFonts.pizzaTitleFont,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          pizzaCubit.pizzaList[pizzaCubit.selectedPizza].description,
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
                            pizzaCubit.pizzaList[pizzaIndex].name,
                            style: AppFonts.pizzaTitleFont,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            pizzaCubit.pizzaList[pizzaIndex].description,
                            style: AppFonts.pizzaDescriptionFont,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
          duration: pizzaChangingDuration,
        );
      },
    );
  }
}

class _ToppingView extends StatelessWidget {
  const _ToppingView({required this.pizzaCubit});

  final PizzaCubit pizzaCubit;

  @override
  Widget build(BuildContext context) {
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
                  final ByteData data = await rootBundle.load(topping.unitImg);
                  final Completer<ui.Image> completer = Completer();
                  ui.decodeImageFromList(
                    Uint8List.view(data.buffer),
                    (ui.Image img) {
                      return completer.complete(img);
                    },
                  );
                  return completer.future;
                }),
                key: ValueKey(topping.img),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TweenAnimationBuilder(
                      key: ValueKey(topping.img),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return CustomPaint(
                          painter: TopperPainter(
                            deviceWidth: context.width.toInt(),
                            deviceHeight: context.height.toInt(),
                            img: snapshot.data!,
                            value: value,
                            positions: topping.positions,
                            pizzaSize: _getPizzaSize(pizzaCubit.pizzaSize, context),
                            context: context,
                          ),
                        );
                      },
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.decelerate,
                    );
                  }
                  return Container();
                },
              ),
          ],
        );
      },
    );
  }
}

class _SizeButton extends StatelessWidget {
  const _SizeButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.isSelected,
  }) : super(key: key);
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
          radius: 24.toSize(context),
          child: Text(
            text,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.0.toSize(context),
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToppingsCounter extends StatelessWidget {
  const _ToppingsCounter({required this.pizzaCubit});

  final PizzaCubit pizzaCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PizzaCubit, PizzaState>(
      bloc: pizzaCubit,
      builder: (context, state) {
        return Text(
          '${pizzaCubit.toppings.length}/${pizzaCubit.toppingList.length}',
          style: const TextStyle(
            color: Colors.grey,
          ),
        );
      },
    );
  }
}

class _AddToCart extends StatelessWidget {
  const _AddToCart({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 35.0.toSize(context)),
      child: Container(
        height: 50.0.toSize(context),
        width: 170.0.toSize(context),
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
            Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 30.toSize(context),
            ),
            const SizedBox(width: 20.0),
            Text(
              AppStrings.addToCart,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.0.toSize(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  const _CircularButton({Key? key, required this.icon}) : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0.toSize(context),
      width: 35.0.toSize(context),
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
}

double _getPizzaSize(PizzaSize size, BuildContext context) {
  switch (size) {
    case PizzaSize.small:
      return 160.toSize(context);
    case PizzaSize.medium:
      return 195.toSize(context);
    case PizzaSize.large:
      return 230.toSize(context);
  }
}
