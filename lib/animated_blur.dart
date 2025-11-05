import 'dart:ui';

import 'package:flutter/material.dart';

class DiscreetWidget extends StatelessWidget {
  final bool discreetModeEnabled;
  final Widget child;
  final double blurSigmaX;
  final double blurSigmaY;

  const DiscreetWidget({
    super.key,
    required this.discreetModeEnabled,
    required this.child,
    this.blurSigmaX = 10,
    this.blurSigmaY = 5,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBlurred(
      sigmaX: discreetModeEnabled ? blurSigmaX : 0,
      sigmaY: discreetModeEnabled ? blurSigmaY : 0,
      child: IgnorePointer(
        ignoring: discreetModeEnabled,
        child: child,
      ),
    );
  }
}

class AnimatedBlurred extends StatefulWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final TileMode tileMode;
  final Curve curve;

  const AnimatedBlurred({
    required this.child,
    this.sigmaX = 5,
    this.sigmaY = 5,
    this.tileMode = TileMode.decal,
    this.curve = Curves.easeIn,
    super.key,
  });

  @override
  State<AnimatedBlurred> createState() => _AnimatedBlurredState();
}

class _AnimatedBlurredState extends State<AnimatedBlurred> with TickerProviderStateMixin {
  late final AnimationController sigmaXController;
  late final AnimationController sigmaYController;

  Animation<double>? sigmaX;
  Animation<double>? sigmaY;

  @override
  void initState() {
    super.initState();
    sigmaXController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    sigmaYController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void didUpdateWidget(covariant AnimatedBlurred oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sigmaX != widget.sigmaX) {
      sigmaX = Tween<double>(
        begin: sigmaX?.value ?? oldWidget.sigmaX,
        end: widget.sigmaX,
      ).animate(CurvedAnimation(parent: sigmaXController, curve: widget.curve));
      sigmaXController
        ..reset()
        ..forward();
    }
    if (oldWidget.sigmaY != widget.sigmaY) {
      sigmaY = Tween<double>(
        begin: sigmaY?.value ?? oldWidget.sigmaY,
        end: widget.sigmaY,
      ).animate(CurvedAnimation(parent: sigmaYController, curve: widget.curve));
      sigmaYController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([sigmaXController, sigmaYController]),
      builder: (context, child) {
        final sx = sigmaX?.value ?? widget.sigmaX;
        final sy = sigmaY?.value ?? widget.sigmaY;
        // if (sx == 0 || sy == 0) {
        //   // Random bug if we set sigmaX or sigmaY to 0, so we just return the child directly
        //   // Bug details: The child was not appearing on rewards page instead of just not getting blurred
        //   //  or it was randomly visible only while scrolling / or from a fraction of a second
        //   return widget.child;
        // }
        return Blurred(
          sigmaX: sx,
          sigmaY: sy,
          tileMode: widget.tileMode,
          child: widget.child,
        );
      },
    );
  }
}

class Blurred extends ImageFiltered {
  Blurred({
    required Widget super.child,
    double sigmaX = 5,
    double sigmaY = 5,
    TileMode tileMode = TileMode.decal,
    super.key,
  }) : super(
         imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY, tileMode: tileMode),
       );
}
