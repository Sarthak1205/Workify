// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/pages/get_started_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final String title = "Work ify";
  int _visibleLetters = 0;

  late AnimationController _dotsController;
  final List<Animation<Offset>> _topDots = [];

  final List<Animation<double>> _topDotFades = [];
  final List<Animation<double>> _topDotScales = [];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _visibleLetters++;
      });

      if (_visibleLetters > title.length) {
        timer.cancel();
        _startDotAnimations();
      }
    });

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _dotsController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (_, __, ___) => const GetStartedPage(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        });
      }
    });
  }

  void _startDotAnimations() async {
    _topDots.clear();
    _topDotFades.clear();
    _topDotScales.clear();

    List<Offset> topStartOffsets = [
      Offset(0.7, 2),
      Offset(0.4, 3),
      Offset(0.2, 3.5)
    ];
    List<Offset> topEndOffsets = [
      Offset(-0.1, -2),
      Offset(0.2, -3),
      Offset(0.6, -3.5)
    ];

    for (int i = 0; i < 3; i++) {
      double start = i * 0.2;
      // double size = (i == 1) ? 12.0 : 8.0;

      _topDots.add(Tween<Offset>(
        begin: topStartOffsets[i],
        end: topEndOffsets[i],
      ).animate(CurvedAnimation(
          parent: _dotsController,
          curve: Interval(start, 1.0, curve: Curves.easeOutBack))));

      _topDotFades.add(CurvedAnimation(
          parent: _dotsController, curve: Interval(start, start + 0.3)));
      _topDotScales.add(CurvedAnimation(
          parent: _dotsController,
          curve: Interval(start, start + 0.5, curve: Curves.elasticOut)));

      setState(() {});
      await Future.delayed(const Duration(milliseconds: 150));
    }

    for (int i = 0; i < 3; i++) {
      // double size = (i == 1) ? 12.0 : 8.0;

      setState(() {});
      await Future.delayed(const Duration(milliseconds: 150));
    }

    _dotsController.forward();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  Widget _buildDot(
          {required Animation<double> fade,
          required Animation<double> scale,
          double size = 24.0}) =>
      FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: Container(
            width: size,
            height: size,
            margin: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated "Workify" text
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(title.length, (index) {
                return AnimatedOpacity(
                  opacity: index < _visibleLetters ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedScale(
                    scale: index < _visibleLetters ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      title[index],
                      style: GoogleFonts.ubuntu(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              }),
            ),

            // Top dots with effects
            ...List.generate(_topDots.length, (i) {
              double size = (i == 1) ? 12.0 : 8.0;
              return SlideTransition(
                position: _topDots[i],
                child: _buildDot(
                    fade: _topDotFades[i], scale: _topDotScales[i], size: size),
              );
            }),

            // Bottom dots with effects
          ],
        ),
      ),
    );
  }
}
