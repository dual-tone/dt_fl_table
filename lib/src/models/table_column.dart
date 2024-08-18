import 'package:flutter/material.dart';

enum DTFLTableColumnFixedPosition { leading, trailing }

class DTFLTableColumn {
  final String key;
  final String label;
  final DTFLTableColumnFixedPosition? fixed;
  final int? widthInPercentage;
  final double? width;
  final Alignment? headerTitleAlignment;

  DTFLTableColumn({
    required this.key,
    required this.label,
    this.fixed,
    this.widthInPercentage,
    this.width,
    this.headerTitleAlignment,
  });
}
