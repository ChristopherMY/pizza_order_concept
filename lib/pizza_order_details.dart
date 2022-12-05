import 'package:flutter/material.dart';
import 'package:pizza_concept/ingredient.dart';
import 'package:pizza_concept/pizza_card_button.dart';
import 'package:pizza_concept/pizza_ingredient.dart';
import 'package:pizza_concept/pizza_order_bloc.dart';
import 'package:pizza_concept/pizza_order_provider.dart';

import './pizza_size_button.dart';

const _pizzaCardSize = 56.0;

class PizzaOrderDetails extends StatelessWidget {
  const PizzaOrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PizzaOrderProvider(
      bloc: PizzaOrderBLoC(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "New Orleans Pizza",
            style: TextStyle(color: Colors.brown, fontSize: 24.0),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.brown,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 50,
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                elevation: 10.0,
                child: Column(
                  children: const <Widget>[
                    Expanded(
                      flex: 4,
                      child: _PizzaDetails(),
                    ),
                    Expanded(
                      flex: 2,
                      child: PizzaIngredients(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              height: _pizzaCardSize,
              width: _pizzaCardSize,
              left: MediaQuery.of(context).size.width / 2 - _pizzaCardSize / 2,
              child: PizzaCardButton(
                onTap: () {
                  print("cart");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _PizzaSizeValue {
  S,
  M,
  L,
}

class _PizzaSizeState {
  _PizzaSizeState(this.value) : factor = _getFactorBySize(value);

  final _PizzaSizeValue value;
  final double factor;

  static double _getFactorBySize(_PizzaSizeValue value) {
    switch (value) {
      case _PizzaSizeValue.S:
        return 0.75;
        break;
      case _PizzaSizeValue.M:
        return 0.85;
        break;
      case _PizzaSizeValue.L:
        return 1.0;
        break;
      default:
        return 1.0;
        break;
    }
  }
}

class _PizzaDetails extends StatefulWidget {
  const _PizzaDetails({Key? key}) : super(key: key);

  @override
  State<_PizzaDetails> createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails>
    with TickerProviderStateMixin {
  final ValueNotifier<bool> _notifierFocused = ValueNotifier(false);
  late AnimationController _animationController;
  final List<Animation> _animationList = <Animation>[];
  BoxConstraints _pizzaConstraints = const BoxConstraints();

  final ValueNotifier<_PizzaSizeState> _pizzaSizeState =
      ValueNotifier(_PizzaSizeState(_PizzaSizeValue.M));

  late AnimationController _animationRotationController;

  void _buildIngredientAnimation() {
    _animationList.clear();
    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.decelerate),
      ),
    );

    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.decelerate),
      ),
    );

    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.decelerate),
      ),
    );

    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.7, curve: Curves.decelerate),
      ),
    );

    _animationList.add(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.decelerate),
      ),
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animationRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationRotationController.dispose();
    super.dispose();
  }

  void _UpdatePizzaSize(_PizzaSizeValue value) {
    _pizzaSizeState.value = _PizzaSizeState(value);
    _animationRotationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final pizzaOrderBloc = PizzaOrderProvider.of(context);
    final total = pizzaOrderBloc!.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: DragTarget<Ingredient>(
            onAccept: (ingredient) {
              print("onAccept");

              _notifierFocused.value = false;

              pizzaOrderBloc.addIngredient(ingredient);

              _buildIngredientAnimation();
              _animationController.forward(from: 0.0);
            },
            onWillAccept: (ingredient) {
              _notifierFocused.value = true;

              print("onWillAccept");
              return true;
            },
            onLeave: (data) {
              print("onLeave");
              _notifierFocused.value = false;
            },
            builder: (context, candidateData, rejectedData) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  _pizzaConstraints = constraints;

                  return ValueListenableBuilder<_PizzaSizeState>(
                      valueListenable: _pizzaSizeState,
                      builder: (context, pizzaSize, child) {
                        return RotationTransition(
                          turns: CurvedAnimation(
                            parent: _animationRotationController,
                            curve: Curves.elasticOut,
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: _notifierFocused,
                                  builder: (context, focussed, __) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      height: focussed
                                          ? constraints.maxHeight *
                                              pizzaSize.factor
                                          : constraints.maxHeight *
                                                  pizzaSize.factor -
                                              10,
                                      child: Stack(
                                        children: [
                                          DecoratedBox(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 15.0,
                                                  color: Colors.black26,
                                                  offset: Offset(0.0, 5.0),
                                                  spreadRadius: 5.0,
                                                ),
                                              ],
                                            ),
                                            child: Image.asset(
                                                "assets/pizza_order/dish.png"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.asset(
                                                "assets/pizza_order/pizza-1.png"),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, snapshot) {
                                  return _BuildIngredientWidget(
                                    animations: _animationList,
                                    pizzaConstraints: _pizzaConstraints,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
              );
            },
          ),
        ),
        const SizedBox(height: 5.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(0.0, 0.0),
                    end: Offset(0.0, animation.value),
                  ),
                ),
                child: child,
              ),
            );
          },
          child: Text(
            "\$$total",
            key: UniqueKey(),
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        ValueListenableBuilder<_PizzaSizeState>(
          valueListenable: _pizzaSizeState,
          builder: (context, pizzaSize, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PizzaSizeButton(
                  text: "S",
                  onTap: () {
                    _UpdatePizzaSize(_PizzaSizeValue.S);
                  },
                  selected: pizzaSize.value == _PizzaSizeValue.S,
                ),
                PizzaSizeButton(
                  text: "M",
                  onTap: () {
                    _UpdatePizzaSize(_PizzaSizeValue.M);
                  },
                  selected: pizzaSize.value == _PizzaSizeValue.M,
                ),
                PizzaSizeButton(
                  text: "L",
                  onTap: () {
                    _UpdatePizzaSize(_PizzaSizeValue.L);
                  },
                  selected: pizzaSize.value == _PizzaSizeValue.L,
                ),
              ],
            );
          },
        )
      ],
    );
  }
}

class _BuildIngredientWidget extends StatelessWidget {
  const _BuildIngredientWidget({
    Key? key,
    required this.animations,
    required this.pizzaConstraints,
  }) : super(key: key);

  final List<Animation> animations;
  final BoxConstraints pizzaConstraints;

  @override
  Widget build(BuildContext context) {
    final listIngredients = PizzaOrderProvider.of(context)!.listIngredients;
    final List<Widget> elements = [];

    if (animations.isEmpty) return const SizedBox.shrink();

    for (int i = 0; i < ingredients.length; i++) {
      Ingredient ingredient = ingredients[i];

      final Widget ingredientWidget = Image.asset(
        ingredient.imageUnit,
        height: 40.0,
      );

      for (int j = 0; j < ingredient.positions.length; j++) {
        final animation = animations[j];
        final position = ingredient.positions[j];
        final positionX = position.dx;
        final positionY = position.dy;

        if (i == ingredients.length - 1) {
          double fromX = 0.0, fromY = 0.0;
          if (j < 1) {
            fromX = -pizzaConstraints.maxWidth * (1 - animation.value);
          } else if (j < 2) {
            fromX = pizzaConstraints.maxWidth * (1 - animation.value);
          } else if (j < 4) {
            fromY = -pizzaConstraints.maxHeight * (1 - animation.value);
          } else {
            fromY = pizzaConstraints.maxHeight * (1 - animation.value);
          }

          //final opacity = animation.value.clamp(0.0, 1.0);
          final opacity = animation.value;

          if (animation.value > 0) {
            elements.add(
              Opacity(
                opacity: opacity,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(
                      fromX + pizzaConstraints.maxWidth * positionX,
                      fromY + pizzaConstraints.maxHeight * positionY,
                    ),
                  child: ingredientWidget,
                ),
              ),
            );
          }
        } else {
          elements.add(
            Transform(
              transform: Matrix4.identity()
                ..translate(
                  pizzaConstraints.maxWidth * positionX,
                  pizzaConstraints.maxHeight * positionY,
                ),
              child: ingredientWidget,
            ),
          );
        }
      }
    }

    return Stack(
      children: elements,
    );
  }
}
