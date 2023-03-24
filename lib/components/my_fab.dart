import 'package:flutter/material.dart';

class MyFAB extends StatelessWidget {
  final Function()? onPressed;
  const MyFAB({Key? key,
  required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
