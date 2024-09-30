import 'package:flutter/material.dart';
import 'package:gym_bro/configs/theme.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? 'Title',
            style: AppTheme.of(context).titleMedium.override(
              fontFamily: 'Inter Tight',
              letterSpacing: 0.0,
            ),
          ),
          Text(
            subtitle ?? 'Subtitle',
            style: AppTheme.of(context).bodyLarge.override(
              fontFamily: 'Inter',
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}