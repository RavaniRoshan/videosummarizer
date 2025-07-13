import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final Animation<double> progressAnimation;
  final Animation<double> pulseAnimation;
  final Map<String, dynamic> currentProcessing;
  final bool isNetworkConnected;

  const ProgressIndicatorWidget({
    Key? key,
    required this.progressAnimation,
    required this.pulseAnimation,
    required this.currentProcessing,
    required this.isNetworkConnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            // Animated Progress Circle
            AnimatedBuilder(
              animation: Listenable.merge([progressAnimation, pulseAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: isNetworkConnected ? pulseAnimation.value : 1.0,
                  child: SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Circle
                        SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 8,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                        ),

                        // Progress Circle
                        SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: CircularProgressIndicator(
                            value: progressAnimation.value,
                            strokeWidth: 8,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isNetworkConnected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),

                        // Progress Percentage
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(currentProcessing["progress"] as double).toInt()}%',
                              style: AppTheme
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isNetworkConnected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                            if (!isNetworkConnected) ...[
                              SizedBox(height: 0.5.h),
                              Text(
                                'Paused',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 3.h),

            // Current Stage
            Text(
              currentProcessing["currentStage"] as String,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 1.h),

            // Estimated Time
            if (isNetworkConnected) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'timer',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Estimated time: ${currentProcessing["estimatedTimeRemaining"]}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 2.h),

            // Processing Status Message
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isNetworkConnected
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.05)
                    : AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isNetworkConnected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2)
                      : AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                isNetworkConnected
                    ? 'Your video is being processed. You can navigate away and return later - processing will continue in the background.'
                    : 'Processing is paused due to network connectivity issues. It will resume automatically when connection is restored.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isNetworkConnected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
