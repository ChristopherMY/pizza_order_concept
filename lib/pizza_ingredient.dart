import 'package:flutter/material.dart';
import 'package:pizza_concept/ingredient.dart';


class PizzaIngredients extends StatelessWidget {
  const PizzaIngredients({Key? key}) : super(key: key);

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
