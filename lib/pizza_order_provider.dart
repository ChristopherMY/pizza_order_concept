import 'package:flutter/cupertino.dart';
import 'package:pizza_concept/pizza_order_bloc.dart';

class PizzaOrderProvider extends InheritedWidget {
  const PizzaOrderProvider({
    Key? key,
    required this.bloc,
    required this.child,
  }) : super(child: child, key: key);

  final PizzaOrderBLoC bloc;
  final Widget child;

  static PizzaOrderBLoC? of(BuildContext context) => context.findAncestorWidgetOfExactType<PizzaOrderProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant PizzaOrderProvider oldWidget) => true;
}
