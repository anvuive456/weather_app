import 'package:flutter/material.dart';
import 'package:weather_app/common/widget/glass_card.dart';
import 'package:weather_app/resources/color.dart';

class WeatherStatGridTile extends StatefulWidget {
  final String label;
  final String stat;
  final IconData icon;
  final int index;

  const WeatherStatGridTile({
    super.key,
    required this.label,
    required this.stat,
    required this.icon,
    this.index = 0,
  });

  @override
  State<WeatherStatGridTile> createState() => _WeatherStatGridTileState();
}

class _WeatherStatGridTileState extends State<WeatherStatGridTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(fontSize: 11, color: Colors.white60),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.stat,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
