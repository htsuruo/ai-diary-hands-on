import 'package:flutter/material.dart';

class CenteredCircularIndicator extends StatelessWidget {
  const CenteredCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
