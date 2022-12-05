import 'package:flutter/material.dart';

class PizzaCardButton extends StatefulWidget {
  const PizzaCardButton({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  State<PizzaCardButton> createState() => _PizzaCardButtonState();
}

class _PizzaCardButtonState extends State<PizzaCardButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animationButton() async {
    await _animationController.forward(from: 0.0);
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onTap;

        await _animationButton();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        child: Container(
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 4.0),
                  spreadRadius: 4.0,
                ),
              ]),
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 35.0,
          ),
        ),
        builder: (context, child) {
          return Transform.scale(
            scale: 2 - _animationController.value,
            child: child!,
          );
        },
      ),
    );
  }
}
