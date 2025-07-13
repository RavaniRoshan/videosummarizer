import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProcessingQueueWidget extends StatelessWidget {
  final List<Map<String, dynamic>> queueData;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const ProcessingQueueWidget({
    Key? key,
    required this.queueData,
    required this.isExpanded,
    required this.onToggleExpanded,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'queued':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'waiting':
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'queued':
        return 'In Queue';
      case 'waiting':
        return 'Waiting';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggleExpanded,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'queue',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Processing Queue (${queueData.length})',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Queue Items
          if (isExpanded) ...[
            const Divider(height: 1),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: queueData.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = queueData[index];
                final status = item["status"] as String;

                return Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      // Queue Position
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                _getStatusColor(status).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: _getStatusColor(status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 3.w),

                      // Video Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["videoTitle"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Text(
                                  item["processingMode"] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  ' • ',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getStatusText(status),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: _getStatusColor(status),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Progress or Actions
                      if (status == 'queued' &&
                          (item["progress"] as double) > 0) ...[
                        SizedBox(
                          width: 12.w,
                          child: Column(
                            children: [
                              Text(
                                '${(item["progress"] as double).toInt()}%',
                                style: AppTheme.lightTheme.textTheme.labelSmall,
                              ),
                              SizedBox(height: 0.5.h),
                              LinearProgressIndicator(
                                value: (item["progress"] as double) / 100,
                                backgroundColor: AppTheme
                                    .lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        IconButton(
                          onPressed: () {
                            // Remove from queue
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Removed "${item["videoTitle"]}" from queue'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 20,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
