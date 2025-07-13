import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProcessingActionsWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onNavigateAway;
  final bool isProcessing;

  const ProcessingActionsWidget({
    Key? key,
    required this.onCancel,
    required this.onNavigateAway,
    required this.isProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Action Buttons
        Row(
          children: [
            // Cancel Button
            if (isProcessing) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: CustomIconWidget(
                    iconName: 'cancel',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 18,
                  ),
                  label: const Text('Cancel Processing'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.error,
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
            ],

            // Navigate Away Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onNavigateAway,
                icon: CustomIconWidget(
                  iconName: 'home',
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                    isProcessing ? 'Continue in Background' : 'Back to Home'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Information Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Processing Information',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              // Information Items
              _buildInfoItem(
                context,
                'background_sync',
                'Background Processing',
                'Processing continues even when you leave this screen or minimize the app.',
              ),
              SizedBox(height: 1.h),

              _buildInfoItem(
                context,
                'notifications',
                'Completion Notification',
                'You\'ll receive a push notification when processing is complete.',
              ),
              SizedBox(height: 1.h),

              _buildInfoItem(
                context,
                'history',
                'Processing History',
                'Access all your processed videos from the Notes Library.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String iconName,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
