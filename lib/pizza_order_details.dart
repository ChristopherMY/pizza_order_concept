import 'package:flutter/material.dart';
import 'package:pizza_concept/ingredient.dart';

const _pizzaCardSize = 56.0;

class PizzaOrderDetails extends StatelessWidget {
  const PizzaOrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    flex: 3,
                    child: _PizzaDetails(),
                  ),
                  Expanded(
                    flex: 2,
                    child: _PizzaIngredients(),
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
            child: const _PizzaCardButton(),
          ),
        ],
      ),
    );
  }
}

class _PizzaDetails extends StatefulWidget {
  const _PizzaDetails({Key? key}) : super(key: key);

  @override
  State<_PizzaDetails> createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails>
    with SingleTickerProviderStateMixin {
  final _listIngredients = <Ingredient>[];
  double _total = 15.0;
  final ValueNotifier<bool> _notifierFocused = ValueNotifier(false);
  late AnimationController _animationController;
  final List<Animation> _animationList = <Animation>[];
  BoxConstraints _pizzaConstraints = const BoxConstraints();

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
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DragTarget<Ingredient>(
                onAccept: (ingredient) {
                  print("onAccept");

                  _notifierFocused.value = false;

                  setState(() {
                    _total++;
                    _listIngredients.add(ingredient);
                  });

                  _buildIngredientAnimation();
                  _animationController.forward(from: 0.0);
                },
                onWillAccept: (ingredient) {
                  _notifierFocused.value = true;

                  for (Ingredient i in _listIngredients) {
                    if (i.compare(ingredient!)) {
                      return false;
                    }
                  }

                  print("onWillAccept");
                  return true;
                },
                onLeave: (data) {
                  print("onLeave");
                  _notifierFocused.value = false;
                },
                builder: (context, candidateData, rejectedData) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      _pizzaConstraints = constraints;

                      return Center(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _notifierFocused,
                          builder: (context, focussed, __) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: focussed
                                  ? constraints.maxHeight
                                  : constraints.maxHeight - 10,
                              child: Stack(
                                children: [
                                  Image.asset("assets/pizza_order/dish.png"),
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
                      );
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
                "\$$_total",
                key: UniqueKey(),
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, snapshot) {
            return _BuildIngredientWidget(
              animations: _animationList,
              ingredients: _listIngredients,
              pizzaConstraints: _pizzaConstraints,
            );
          },
        ),
      ],
    );
  }
}

class _BuildIngredientWidget extends StatelessWidget {
  const _BuildIngredientWidget({
    Key? key,
    required this.animations,
    required this.ingredients,
    required this.pizzaConstraints,
  }) : super(key: key);

  final List<Animation> animations;
  final List<Ingredient> ingredients;
  final BoxConstraints pizzaConstraints;

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = [];

    if (animations.isEmpty) return const SizedBox.shrink();

    for (int i = 0; i < ingredients.length; i++) {
      Ingredient ingredient = ingredients[i];

      final Widget ingredientWidget = Image.asset(
        ingredient.image,
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

class _PizzaCardButton extends StatelessWidget {
  const _PizzaCardButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orange.withOpacity(0.5),
            Colors.orange,
          ],
        ),
      ),
      child: const Icon(
        Icons.shopping_cart_outlined,
        color: Colors.white,
        size: 35.0,
      ),
    );
  }
}

class _PizzaIngredients extends StatelessWidget {
  const _PizzaIngredients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ingredients.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return _PizzaIngredientItem(ingredient: ingredient);
      },
    );
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  const _PizzaIngredientItem({Key? key, required this.ingredient})
      : super(key: key);

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      margin: const EdgeInsets.symmetric(horizontal: 7.0),
      padding: const EdgeInsets.all(5.0),
      height: 45.0,
      width: 45.0,
      decoration: const BoxDecoration(
        color: Color(0xFFF5EED3),
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        ingredient.image,
        fit: BoxFit.contain,
      ),
    );

    return Center(
      child: Draggable<Ingredient>(
        feedback: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10.0,
                  color: Colors.black26,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 5.0),
            ],
          ),
          child: child,
        ),
        data: ingredient,
        child: child,
      ),
    );
  }
}
