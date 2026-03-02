import 'dart:math';

import 'package:flutter/material.dart';

// ── Public API ────────────────────────────────────────────────────────────────

/// Full-screen animated background that reacts to weather condition + time.
///
/// Gradient changes smoothly with [AnimatedContainer].
/// Rain / snow overlays are drawn by [CustomPainter] driven by an
/// [AnimationController] that loops continuously.
class WeatherBackground extends StatefulWidget {
  /// WeatherAPI condition code (e.g. 1000 = clear, 1183 = heavy rain).
  final int conditionCode;

  /// 1 = daytime, 0 = night (from [WeatherModel.isDay]).
  final bool isDay;

  final Widget child;

  const WeatherBackground({
    super.key,
    required this.conditionCode,
    required this.isDay,
    required this.child,
  });

  @override
  State<WeatherBackground> createState() => _WeatherBackgroundState();
}

// ── State ─────────────────────────────────────────────────────────────────────

class _WeatherBackgroundState extends State<WeatherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late _BgConfig _cfg;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _cfg = _buildConfig();
    _particles = _generateParticles(_cfg.particleType);
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
  }

  @override
  void didUpdateWidget(WeatherBackground old) {
    super.didUpdateWidget(old);
    if (old.conditionCode != widget.conditionCode ||
        old.isDay != widget.isDay) {
      final next = _buildConfig();
      if (next.particleType != _cfg.particleType) {
        _particles = _generateParticles(next.particleType);
      }
      setState(() => _cfg = next);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Config ──────────────────────────────────────────────────────────────────

  _BgConfig _buildConfig() {
    final hour = DateTime.now().hour;
    final code = widget.conditionCode;

    if (_isStormy(code)) return _BgConfig.storm();
    if (_isRainy(code)) return _BgConfig.rain();
    if (_isSnowy(code)) return _BgConfig.snow();
    if (_isFoggy(code)) return _BgConfig.fog(widget.isDay);
    if (_isCloudy(code)) return _BgConfig.cloudy(widget.isDay);
    return _BgConfig.clear(widget.isDay, hour);
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasParticles = _cfg.particleType != _ParticleType.none;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _cfg.colors,
        ),
      ),
      child: Stack(
        children: [
          if (hasParticles)
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => CustomPaint(
                    painter: _ParticlePainter(
                      particles: _particles,
                      progress: _ctrl.value,
                      type: _cfg.particleType,
                    ),
                  ),
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

// ── Condition helpers ─────────────────────────────────────────────────────────

bool _isStormy(int c) =>
    c == 1087 || c == 1273 || c == 1276 || c == 1279 || c == 1282;

bool _isRainy(int c) =>
    c == 1063 ||
    c == 1072 ||
    (c >= 1150 && c <= 1201) ||
    (c >= 1204 && c <= 1207) ||
    (c >= 1240 && c <= 1246) ||
    (c >= 1249 && c <= 1252);

bool _isSnowy(int c) =>
    c == 1066 ||
    c == 1069 ||
    c == 1114 ||
    c == 1117 ||
    (c >= 1210 && c <= 1225) ||
    (c >= 1255 && c <= 1264) ||
    c == 1237;

bool _isFoggy(int c) => c == 1030 || c == 1135 || c == 1147;

bool _isCloudy(int c) => c == 1006 || c == 1009;

// ── Background config ─────────────────────────────────────────────────────────

enum _ParticleType { none, rain, storm, snow }

class _BgConfig {
  final List<Color> colors;
  final _ParticleType particleType;

  const _BgConfig(this.colors, [this.particleType = _ParticleType.none]);

  // ── Weather-based configs ──────────────────────────────────────────────────

  factory _BgConfig.storm() => const _BgConfig(
        [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0D0D1A)],
        _ParticleType.storm,
      );

  factory _BgConfig.rain() => const _BgConfig(
        [Color(0xFF2C3E50), Color(0xFF1E2D3D), Color(0xFF152535)],
        _ParticleType.rain,
      );

  factory _BgConfig.snow() => const _BgConfig(
        [Color(0xFF8EA8C3), Color(0xFFCBD5E8), Color(0xFF9EAFC7)],
        _ParticleType.snow,
      );

  factory _BgConfig.fog(bool isDay) => _BgConfig(
        isDay
            ? const [Color(0xFF8B9BAA), Color(0xFF6B7E8E), Color(0xFF4A5C6A)]
            : const [Color(0xFF3D4C58), Color(0xFF252E35), Color(0xFF1A2028)],
      );

  factory _BgConfig.cloudy(bool isDay) => _BgConfig(
        isDay
            ? const [Color(0xFF546E7A), Color(0xFF37474F), Color(0xFF263238)]
            : const [Color(0xFF263238), Color(0xFF1C272D), Color(0xFF111B21)],
      );

  // ── Time-of-day clear configs ──────────────────────────────────────────────

  factory _BgConfig.clear(bool isDay, int hour) {
    if (!isDay || hour >= 21 || hour < 5) return const _BgConfig._night();
    if (hour >= 5 && hour < 7) return const _BgConfig._dawn();
    if (hour >= 7 && hour < 10) return const _BgConfig._morning();
    if (hour >= 10 && hour < 17) return const _BgConfig._day();
    if (hour >= 17 && hour < 20) return const _BgConfig._evening();
    return const _BgConfig._dusk();
  }

  const _BgConfig._night()
      : colors = const [Color(0xFF0D1B4E), Color(0xFF0B1437), Color(0xFF07091F)],
        particleType = _ParticleType.none;

  const _BgConfig._dawn()
      : colors = const [Color(0xFF2C1654), Color(0xFFBF5A30), Color(0xFF1B4F72)],
        particleType = _ParticleType.none;

  const _BgConfig._morning()
      : colors = const [Color(0xFF1A78C2), Color(0xFF4FC3F7), Color(0xFF1B7AC2)],
        particleType = _ParticleType.none;

  const _BgConfig._day()
      : colors = const [Color(0xFF1E90FF), Color(0xFF2979D8), Color(0xFF0B5FA5)],
        particleType = _ParticleType.none;

  const _BgConfig._evening()
      : colors = const [Color(0xFFFF7043), Color(0xFFBD4F6C), Color(0xFF303960)],
        particleType = _ParticleType.none;

  const _BgConfig._dusk()
      : colors = const [Color(0xFF4A235A), Color(0xFF1B2B6B), Color(0xFF0D1B4E)],
        particleType = _ParticleType.none;
}

// ── Particle data ─────────────────────────────────────────────────────────────

class _Particle {
  final double x;      // initial X (0-1 normalised)
  final double y;      // initial Y (0-1 normalised)
  final double speed;  // fall speed multiplier per loop
  final double size;   // rain: length fraction | snow: radius px
  final double drift;  // snow: horizontal oscillation amplitude
  final double phase;  // snow: sine phase offset

  const _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    this.drift = 0,
    this.phase = 0,
  });
}

List<_Particle> _generateParticles(_ParticleType type) {
  final rng = Random();
  switch (type) {
    case _ParticleType.rain:
      return List.generate(100, (_) => _Particle(
            x: rng.nextDouble(),
            y: rng.nextDouble(),
            speed: 0.8 + rng.nextDouble() * 0.6,
            size: 0.025 + rng.nextDouble() * 0.02,
          ));
    case _ParticleType.storm:
      return List.generate(180, (_) => _Particle(
            x: rng.nextDouble(),
            y: rng.nextDouble(),
            speed: 1.5 + rng.nextDouble() * 1.0,
            size: 0.035 + rng.nextDouble() * 0.025,
          ));
    case _ParticleType.snow:
      return List.generate(60, (_) => _Particle(
            x: rng.nextDouble(),
            y: rng.nextDouble(),
            speed: 0.12 + rng.nextDouble() * 0.15,
            size: 2.0 + rng.nextDouble() * 3.0,
            drift: 0.02 + rng.nextDouble() * 0.04,
            phase: rng.nextDouble() * 2 * pi,
          ));
    case _ParticleType.none:
      return [];
  }
}

// ── CustomPainter ─────────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress; // 0-1 looping
  final _ParticleType type;

  const _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case _ParticleType.rain:
        _paintRain(canvas, size, storm: false);
      case _ParticleType.storm:
        _paintRain(canvas, size, storm: true);
      case _ParticleType.snow:
        _paintSnow(canvas, size);
      case _ParticleType.none:
        break;
    }
  }

  // Normal rain: slight slant, thin lines
  // Storm: steeper angle, thicker lines, denser
  void _paintRain(Canvas canvas, Size size, {required bool storm}) {
    const slantRad = 0.18; // ~10° from vertical
    final paint = Paint()
      ..color = Colors.white.withAlpha(storm ? 100 : 80)
      ..strokeWidth = storm ? 1.5 : 0.9
      ..strokeCap = StrokeCap.round;

    for (final p in particles) {
      final y = (p.y + progress * p.speed) % 1.0;
      // Drop shifts right slightly as it falls — gives "falling diagonally" feel
      final x = (p.x + y * slantRad * 0.5 + 1.0) % 1.0;

      final px = x * size.width;
      final py = y * size.height;
      final dropH = p.size * size.height;

      canvas.drawLine(
        Offset(px, py),
        Offset(px + dropH * sin(slantRad), py + dropH * cos(slantRad)),
        paint,
      );
    }
  }

  void _paintSnow(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final y = (p.y + progress * p.speed) % 1.0;
      // Gentle sinusoidal horizontal drift
      final xDrift = sin(progress * 2 * pi * 2 + p.phase) * p.drift;
      final x = (p.x + xDrift + 1.0) % 1.0;

      // Opacity oscillates slightly for twinkling effect
      final opacity = 0.5 + 0.3 * sin(progress * 2 * pi * 3 + p.phase);
      paint.color = Colors.white.withAlpha((opacity * 255).round());

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) =>
      old.progress != progress || old.type != type;
}
