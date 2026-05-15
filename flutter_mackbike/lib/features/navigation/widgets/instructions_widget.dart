import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/navigation_view_model.dart';

class InstructionsWidget extends StatelessWidget {
  const InstructionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NavigationViewModel>();
    final route = viewModel.currentRoute;

    if (route == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((255 * 0.5).round()),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distance: ${(route.distance / 1000).toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: route.instructions.length,
                itemBuilder: (context, index) {
                  final instruction = route.instructions[index];
                  return ListTile(
                    leading: Icon(_getIconForSign(instruction.sign)),
                    title: Text(instruction.text),
                    subtitle: Text(
                      '${instruction.distance.toStringAsFixed(1)} m',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForSign(int sign) {
    switch (sign) {
      case -2:
        return Icons.turn_left;
      case 2:
        return Icons.turn_right;
      case 7:
        return Icons.fork_right;
      case 0:
        return Icons.straight;
      case 4:
        return Icons.flag;
      default:
        return Icons.circle;
    }
  }
}
