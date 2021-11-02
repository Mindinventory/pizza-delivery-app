import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_delivery/common/app_fonts.dart';
import 'package:pizza_delivery/common/swipe_detector.dart';
import 'package:pizza_delivery/cubit/pizza_cubit.dart';
import 'package:pizza_delivery/viewmodel/pizza_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PizzaCubit pizzaCubit = PizzaCubit();
  int count=0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        child: Column(
          children: [_buildTopTitle(),
            _buildPizza(),
            _buildPriceAndSize()
          ],
        ),
      ),
    );
  }

  Widget _buildPizzaNameAndDesc() {
    return BlocBuilder<PizzaCubit, PizzaState>(
      bloc: pizzaCubit,
      builder: (context, state) {

        return Column(
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
        );
      },
    );
  }

  Widget _buildTopTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade600,
            size: 30,
          ),
          onTap: () {},
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
          child: Icon(
            Icons.favorite_border_outlined,
            color: Colors.grey.shade600,
            size: 30,
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPizza() {

    final deviceWidth=MediaQuery.of(context).size.width;
    const pizzaSize=230.0;
    const plateSize=250.0;
    const prevPizzaSize=200.0;
    return BlocBuilder<PizzaCubit,PizzaState>(
      bloc: pizzaCubit,
      builder: (context, state) {
      bool? rightSwipe=(state.runtimeType  == PizzaChangeState)?(state as PizzaChangeState).rightSide:null;
        return SwipeDetector(
          onSwipe: (rightSwipe) {
            if(rightSwipe){
              if(  pizzaCubit.selectedPizza>0) {
                count--;
                pizzaCubit.emit(PizzaChangeState(rightSide: rightSwipe));
              }
            }
            else{
              if(pizzaCubit.pizzaList.length-1>pizzaCubit.selectedPizza) {
                count++;
                pizzaCubit.emit(PizzaChangeState(rightSide: rightSwipe));
              }
            }

            // print('SWIPE ${rightSwipe?'RIGHT':'LEFT'}');
          },
          child: SizedBox(
            height: 350,
            child: TweenAnimationBuilder(
              key: ValueKey(count),
              tween: Tween<double>(begin: 0,end: 1),
              onEnd: (){
                if(rightSwipe!) {
                  pizzaCubit.selectedPizza--;
                }
                else {
                  pizzaCubit.selectedPizza++;
                }
                pizzaCubit.emit(PizzaChangedState());
              },
              builder: (context, double value,child){
        final pizzaChangedSize=rightSwipe!=null?(value<0.3)?(pizzaSize-((value+0.7)*(pizzaSize-prevPizzaSize))):prevPizzaSize:pizzaSize;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: PhysicalModel(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(125),
                        color: Colors.brown.shade800,
                        elevation: 3,
                        child: Image.asset('assets/icons/pizza_plate.png',
                          width: plateSize,
                          height: plateSize,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset:rightSwipe!=null ?Offset(value*(rightSwipe?(deviceWidth/2)+(prevPizzaSize/2):-((deviceWidth/2)+(prevPizzaSize/2))),0):const Offset(0, 0),
                      child: Transform.rotate(
                        angle: pi*((value-0.2)>0?value-0.2:0),
                        child: Image.asset(pizzaCubit.pizzaList[pizzaCubit.selectedPizza].imgPath,
                          width: pizzaChangedSize,
                          height: pizzaChangedSize,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    if(rightSwipe!=null)
                    Transform.translate(
                      offset: Offset((1-value)*(rightSwipe?-((deviceWidth/2)+(pizzaSize/2)):(deviceWidth/2)+(pizzaSize/2)),0),
                      child: Transform.rotate(
                        angle:pi*((value-0.4)>0?value-0.2:0),
                        child: Image.asset(pizzaCubit.pizzaList[pizzaCubit.selectedPizza+(rightSwipe?-1:1)].imgPath,
                          width: pizzaSize,
                          height: pizzaSize,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    )
                  ],
                );
              }, duration: const Duration(milliseconds: 600),curve: Curves.easeInOut,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceAndSize() {
    return Column(
      children: [
        Text('\$${pizzaCubit.pizzaList[pizzaCubit.selectedPizza].price.toStringAsFixed(2)}',style: AppFonts.pizzaPriceFont,)
      ],
    );
  }
}
