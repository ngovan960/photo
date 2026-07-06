import 'package:flutter/material.dart';

class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? semanticHint;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticLabel,
    this.semanticHint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      child: GestureDetector(
        onTap: onPressed,
        child: child,
      ),
    );
  }
}

class AccessibleImage extends StatelessWidget {
  final Widget child;
  final String semanticLabel;

  const AccessibleImage({
    super.key,
    required this.child,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: child,
    );
  }
}

class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final double? size;
  final Color? color;

  const AccessibleIcon({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}
