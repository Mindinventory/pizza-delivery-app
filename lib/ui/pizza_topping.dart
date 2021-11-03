
import 'package:flutter/material.dart';

class PizzaToppingListView extends StatelessWidget {
  static const List<String> listItem = [
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
  final PageController pageController=PageController(
      viewportFraction: 0.2
  );
  PizzaToppingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      pageSnapping: true,
      clipBehavior: Clip.none,
      controller: pageController,
      itemBuilder: (context, i) {
        return ToppingItem(img: listItem[i], selectionChange: (bool){});
      },
      itemCount: listItem.length,);
  }
}
class ToppingItem extends StatefulWidget {
  const ToppingItem({Key? key,required this.img,required this.selectionChange}) : super(key: key);
  final String img;
  final void Function(bool) selectionChange;

  @override
  State<ToppingItem> createState() => _ToppingItemState();
}

class _ToppingItemState extends State<ToppingItem> {
  bool selected=false;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        setState(() {
          selected=!selected;
        });
        widget.selectionChange.call(selected);
      },
      child: Opacity(
        opacity: selected?0.6:1,
        child: Image.asset(
          widget.img,
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

