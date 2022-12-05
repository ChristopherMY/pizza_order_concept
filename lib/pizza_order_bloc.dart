import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:pizza_concept/ingredient.dart';

class PizzaOrderBLoC extends ChangeNotifier{
  final listIngredients = <Ingredient>[];
  double total = 15.0;

  void addIngredient(Ingredient ingredient){
    listIngredients.add(ingredient);
    total++;
    notifyListeners();
  }

  bool containsIngredient(Ingredient ingredient){
    for (Ingredient i in listIngredients) {
      if (i.compare(ingredient)) {
        return true;
      }
    }
    return false;
  }
}