import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        bg = AppColors.successGreen.withOpacity(0.12);
        text = AppColors.successGreen;
        break;
      case 'MAINTENANCE':
        bg = AppColors.warningAmber.withOpacity(0.12);
        text = AppColors.warningAmber;
        break;
      case 'INACTIVE':
      default:
        bg = AppColors.textSecondary.withOpacity(0.12);
        text = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

