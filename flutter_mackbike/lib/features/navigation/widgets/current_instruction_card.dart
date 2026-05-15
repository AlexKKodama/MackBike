import 'package:flutter/material.dart';
import 'package:flutter_mackbike/features/navigation/models/instruction_model.dart';

class CurrentInstructionCard extends StatelessWidget {
  final InstructionModel instruction;

  const CurrentInstructionCard({super.key, required this.instruction});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(_getIconForSign(instruction.sign), size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instruction.text,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${instruction.distance.toStringAsFixed(0)} m',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
