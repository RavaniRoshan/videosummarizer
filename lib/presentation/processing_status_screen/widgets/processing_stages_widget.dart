import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProcessingStagesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> stages;

  const ProcessingStagesWidget({
    Key? key,
    required this.stages,
  }) : super(key: key);

  Color _getStageColor(String status) {
    switch (status) {
      case 'completed':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'active':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'pending':
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStageIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'active':
        return Icons.radio_button_checked;
      case 'pending':
      default:
        return Icons.radio_button_unchecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Processing Stages',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Stages List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stages.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
              itemBuilder: (context, index) {
                final stage = stages[index];
                final status = stage["status"] as String;
                final stageName = stage["name"] as String;
                final iconName = stage["icon"] as String;

                return Row(
                  children: [
                    // Stage Status Icon
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: _getStageColor(status).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getStageColor(status).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _getStageIcon(status),
                        color: _getStageColor(status),
                        size: 5.w,
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Stage Icon
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _getStageColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: iconName,
                        color: _getStageColor(status),
                        size: 20,
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Stage Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stageName,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: status == 'active'
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: status == 'pending'
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          if (status == 'active') ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              'In Progress...',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ] else if (status == 'completed') ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              'Completed',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Connection Line (except for last item)
                    if (index < stages.length - 1) ...[
                      Container(
                        width: 2,
                        height: 3.h,
                        color: index <
                                stages
                                    .indexWhere((s) => s["status"] == "pending")
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.2),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
