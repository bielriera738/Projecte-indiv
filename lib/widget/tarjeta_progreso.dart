import 'package:flutter/material.dart';

/// Tarjeta de progreso de macro con barra.
class MacroProgressCard extends StatelessWidget {
  final String label;
  final String consumed;
  final String goal;
  final Color color;
  final double consumedValue;
  final double goalValue;

  const MacroProgressCard({
    super.key,
    required this.label,
    required this.consumed,
    required this.goal,
    required this.color,
    required this.consumedValue,
    required this.goalValue,
  });

  double get _percentage {
    if (goalValue == 0) return 0;
    final p = consumedValue / goalValue;
    return p > 1 ? 1 : p;
  }

  Color get _progressColor {
    final pct = _percentage * 100;
    if (pct < 70) return Colors.redAccent;
    if (pct < 100) return Colors.amberAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F4D3C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$consumed / $goal',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _percentage,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
            ),
          ),
        ],
      ),
    );
  }
}
