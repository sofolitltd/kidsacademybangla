import 'package:flutter/material.dart';

/// Minimal local Lucide-like icon wrapper to avoid external dependency.
/// Maps commonly used names in this project to nearest Material icons.
class LucideIcons {
  LucideIcons._();

  static const IconData star = Icons.star;
  static const IconData play = Icons.play_arrow;
  static const IconData pause = Icons.pause;
  static const IconData stop = Icons.stop;
  static const IconData squaresFour = Icons.grid_view;
  static const IconData list = Icons.view_list;
  static const IconData speakerHigh = Icons.volume_up;
  static const IconData speakerNone = Icons.volume_off;
  static const IconData skipBack = Icons.skip_previous;
  static const IconData skipForward = Icons.skip_next;
  static const IconData caretRight = Icons.chevron_right;
}

class LucideIcon extends Icon {
  const LucideIcon(
    IconData icon, {
    Key? key,
    double? size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) : super(
         icon,
         key: key,
         size: size,
         color: color,
         semanticLabel: semanticLabel,
         textDirection: textDirection,
       );
}
