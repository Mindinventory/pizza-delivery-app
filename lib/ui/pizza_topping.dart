
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_delivery/cubit/pizza_cubit.dart';

class PizzaToppingListView extends StatelessWidget {
  // static const List<String> listItem = [
  //   'assets/images/toppings/green_chillies_thumb.png',
  //   'assets/images/toppings/green_peppers_thumb.png',
  //   'assets/images/toppings/halloumi_thumb.png',
  //   'assets/images/toppings/mushrooms_thumb.png',
  //   'assets/images/toppings/olives_thumb.png',
  //   'assets/images/toppings/onions_thumb.png',
  //   'assets/images/toppings/pineapples_thumb.png',
  //   'assets/images/toppings/sweetcorn_thumb.png',
  //   'assets/images/toppings/tomatos_thumb.png',
  // ];
  final PageController pageController=PageController(
      viewportFraction: 0.2
  );
  PizzaToppingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listItem=BlocProvider.of<PizzaCubit>(context,listen: false).toppingList;
    return PageView.builder(
      pageSnapping: true,
      scrollBehavior: const CupertinoScrollBehavior(),
      clipBehavior: Clip.none,
      controller: pageController,
      itemBuilder: (context, i) {
        return ToppingItem(img: listItem[i].img, selectionChange: (bool){
          listItem[i].selected=bool;
          if(bool){
            print('TOppinggggg ${listItem[i].img}');
            BlocProvider.of<PizzaCubit>(context).addTopping(context, listItem[i]);
          }
          else{
            BlocProvider.of<PizzaCubit>(context).removeTopping(listItem[i]);
          }
        }, selected: listItem[i].selected,);
      },
      itemCount: listItem.length,);
  }
}
class ToppingItem extends StatefulWidget {
  const ToppingItem({Key? key,required this.img,required this.selectionChange,required this.selected}) : super(key: key);
  final String img;
  final bool selected;
  final void Function(bool) selectionChange;

  @override
  State<ToppingItem> createState() => _ToppingItemState();
}

class _ToppingItemState extends State<ToppingItem> {
  bool selected=false;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){

          selected=!selected;
          setState(() {
          });
          widget.selectionChange.call(selected);
        },
        child: Opacity(
          opacity: selected?0.3:1,
          child: Image.asset(
            widget.img,
            width: 50,
            height: 50,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

