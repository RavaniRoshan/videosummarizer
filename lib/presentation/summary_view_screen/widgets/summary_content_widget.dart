import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SummaryContentWidget extends StatelessWidget {
  final List<Map<String, dynamic>> content;
  final String mode;
  final Function(String) onTextSelected;

  const SummaryContentWidget({
    super.key,
    required this.content,
    required this.mode,
    required this.onTextSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          content.map((item) => _buildContentItem(context, item)).toList(),
    );
  }

  Widget _buildContentItem(BuildContext context, Map<String, dynamic> item) {
    switch (item['type']) {
      case 'slide':
        return _buildSlideContent(context, item);
      case 'paragraph':
        return _buildParagraphContent(context, item);
      case 'action':
        return _buildActionContent(context, item);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSlideContent(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Slide ${content.indexOf(item) + 1}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SelectableText(
            item['title'] ?? '',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
            onSelectionChanged: (selection, cause) {
              if (selection.textInside(item['title'] ?? '').isNotEmpty) {
                onTextSelected(selection.textInside(item['title'] ?? ''));
              }
            },
          ),
          SizedBox(height: 1.h),
          SelectableText(
            item['content'] ?? '',
            style: AppTheme.lightTheme.textTheme.bodyLarge,
            onSelectionChanged: (selection, cause) {
              if (selection.textInside(item['content'] ?? '').isNotEmpty) {
                onTextSelected(selection.textInside(item['content'] ?? ''));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParagraphContent(
      BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: SelectableText(
        item['content'] ?? '',
        style: AppTheme.lightTheme.textTheme.bodyLarge,
        onSelectionChanged: (selection, cause) {
          if (selection.textInside(item['content'] ?? '').isNotEmpty) {
            onTextSelected(selection.textInside(item['content'] ?? ''));
          }
        },
      ),
    );
  }

  Widget _buildActionContent(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: item['completed'] == true
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: item['completed'] == true
                ? CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 16,
                  )
                : Center(
                    child: Text(
                      '${item['step']}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  item['title'] ?? '',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    decoration: item['completed'] == true
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  onSelectionChanged: (selection, cause) {
                    if (selection.textInside(item['title'] ?? '').isNotEmpty) {
                      onTextSelected(selection.textInside(item['title'] ?? ''));
                    }
                  },
                ),
                SizedBox(height: 0.5.h),
                SelectableText(
                  item['content'] ?? '',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  onSelectionChanged: (selection, cause) {
                    if (selection
                        .textInside(item['content'] ?? '')
                        .isNotEmpty) {
                      onTextSelected(
                          selection.textInside(item['content'] ?? ''));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
