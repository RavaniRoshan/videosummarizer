import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RichTextToolbarWidget extends StatelessWidget {
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isBulletList;
  final bool isNumberedList;
  final double textSize;
  final bool isVoiceRecording;
  final bool isExpanded;
  final VoidCallback onToggleBold;
  final VoidCallback onToggleItalic;
  final VoidCallback onToggleUnderline;
  final VoidCallback onToggleBulletList;
  final VoidCallback onToggleNumberedList;
  final Function(double) onTextSizeChanged;
  final VoidCallback onVoiceRecording;
  final VoidCallback onToggleExpanded;

  const RichTextToolbarWidget({
    Key? key,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.isBulletList,
    required this.isNumberedList,
    required this.textSize,
    required this.isVoiceRecording,
    required this.isExpanded,
    required this.onToggleBold,
    required this.onToggleItalic,
    required this.onToggleUnderline,
    required this.onToggleBulletList,
    required this.onToggleNumberedList,
    required this.onTextSizeChanged,
    required this.onVoiceRecording,
    required this.onToggleExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isExpanded ? 20.h : 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Collapse/Expand Button
          Container(
            width: double.infinity,
            height: 6.h,
            child: Center(
              child: GestureDetector(
                onTap: onToggleExpanded,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: isExpanded
                            ? 'keyboard_arrow_down'
                            : 'keyboard_arrow_up',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        isExpanded ? 'Hide Toolbar' : 'Show Toolbar',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isExpanded) ...[
            // Main Formatting Controls
            Container(
              height: 7.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  _buildFormatButton(
                    icon: 'format_bold',
                    isActive: isBold,
                    onTap: onToggleBold,
                  ),
                  _buildFormatButton(
                    icon: 'format_italic',
                    isActive: isItalic,
                    onTap: onToggleItalic,
                  ),
                  _buildFormatButton(
                    icon: 'format_underlined',
                    isActive: isUnderline,
                    onTap: onToggleUnderline,
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    width: 1,
                    height: 4.h,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  SizedBox(width: 2.w),
                  _buildFormatButton(
                    icon: 'format_list_bulleted',
                    isActive: isBulletList,
                    onTap: onToggleBulletList,
                  ),
                  _buildFormatButton(
                    icon: 'format_list_numbered',
                    isActive: isNumberedList,
                    onTap: onToggleNumberedList,
                  ),
                  Spacer(),
                  // Voice Recording Button
                  GestureDetector(
                    onTap: onVoiceRecording,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: isVoiceRecording
                            ? AppTheme.errorLight
                            : AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: isVoiceRecording ? 'stop' : 'mic',
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Text Size Controls
            Container(
              height: 7.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    'Text Size:',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Row(
                      children: [
                        _buildTextSizeButton('S', 12.0),
                        _buildTextSizeButton('M', 16.0),
                        _buildTextSizeButton('L', 20.0),
                        _buildTextSizeButton('XL', 24.0),
                        Spacer(),
                        Text(
                          '\${textSize.toInt()}sp',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormatButton({
    required String icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 10.w,
        height: 10.w,
        margin: EdgeInsets.only(right: 2.w),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: AppTheme.lightTheme.colorScheme.primary)
              : null,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTextSizeButton(String label, double size) {
    final isSelected = textSize == size;

    return GestureDetector(
      onTap: () => onTextSizeChanged(size),
      child: Container(
        width: 8.w,
        height: 8.w,
        margin: EdgeInsets.only(right: 2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ),
        ),
      ),
    );
  }
}
