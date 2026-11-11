import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    IconData icon;

    switch (status.toUpperCase()) {
      case 'AVAILABLE':
      case 'ACTIVE':
        bg = AppColors.successGreen.withOpacity(0.12);
        text = AppColors.successGreen;
        icon = Icons.check_circle_outline;
        break;
      case 'IN_TRIP':
        bg = AppColors.corporateBlue.withOpacity(0.12);
        text = AppColors.corporateBlue;
        icon = Icons.near_me_outlined;
        break;
      case 'MAINTENANCE':
        bg = AppColors.warningAmber.withOpacity(0.15);
        text = const Color(0xFFD97706); // Darker amber for readability
        icon = Icons.build_circle_outlined;
        break;
      case 'INACTIVE':
      default:
        bg = AppColors.textSecondary.withOpacity(0.12);
        text = AppColors.textSecondary;
        icon = Icons.pause_circle_outline;
        break;
    }

    final formatted = status.replaceAll('_', ' ').toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: text.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 4),
          Text(
            formatted,
            style: TextStyle(
              color: text,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
