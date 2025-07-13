import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteCardWidget extends StatelessWidget {
  final Map<String, dynamic> note;
  final bool isSelected;
  final bool isSelectionMode;
  final bool isGridView;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;
  final Function(String) onTagTap;

  const NoteCardWidget({
    Key? key,
    required this.note,
    required this.isSelected,
    required this.isSelectionMode,
    this.isGridView = false,
    required this.onTap,
    required this.onLongPress,
    required this.onFavoriteToggle,
    required this.onDelete,
    required this.onTagTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Dismissible(
        key: Key('note_${note['id']}'),
        background: _buildSwipeBackground(true),
        secondaryBackground: _buildSwipeBackground(false),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onDelete();
          } else {
            onFavoriteToggle();
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.only(bottom: isGridView ? 0 : 2.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary, width: 2)
                : Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildContent(),
              if (!isGridView) _buildVideoInfo(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isLeft) {
    return Container(
      margin: EdgeInsets.only(bottom: isGridView ? 0 : 2.h),
      decoration: BoxDecoration(
        color: isLeft ? Colors.red : AppTheme.lightTheme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeft ? 'delete' : 'favorite',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            isLeft ? 'Delete' : 'Favorite',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          if (isSelectionMode)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              child: CustomIconWidget(
                iconName:
                    isSelected ? 'check_circle' : 'radio_button_unchecked',
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                size: 20,
              ),
            ),
          Expanded(
            child: Text(
              note['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: isGridView ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!isSelectionMode)
            GestureDetector(
              onTap: onFavoriteToggle,
              child: CustomIconWidget(
                iconName: (note['isFavorite'] as bool)
                    ? 'favorite'
                    : 'favorite_border',
                color: (note['isFavorite'] as bool)
                    ? Colors.red
                    : AppTheme.lightTheme.colorScheme.outline,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Text(
        note['snippet'] as String,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
        maxLines: isGridView ? 3 : 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CustomImageWidget(
              imageUrl: note['videoThumbnail'] as String,
              width: 15.w,
              height: 10.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note['videoTitle'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  note['duration'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final timestamp = note['timestamp'] as DateTime;
    final timeAgo = _getTimeAgo(timestamp);
    final tags = note['tags'] as List<String>;

    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isGridView) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CustomImageWidget(
                    imageUrl: note['videoThumbnail'] as String,
                    width: 12.w,
                    height: 8.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    note['videoTitle'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
          Wrap(
            spacing: 1.w,
            runSpacing: 0.5.h,
            children: tags
                .take(isGridView ? 2 : 3)
                .map((tag) => GestureDetector(
                      onTap: () => onTagTap(tag),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getTagColor(tag).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getTagColor(tag).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          tag,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getTagColor(tag),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          if (tags.length > (isGridView ? 2 : 3))
            Container(
              margin: EdgeInsets.only(top: 0.5.h),
              child: Text(
                '+${tags.length - (isGridView ? 2 : 3)} more',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 14,
              ),
              SizedBox(width: 1.w),
              Text(
                timeAgo,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  note['noteType'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'ml':
      case 'education':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'flutter':
      case 'development':
      case 'technical':
        return Colors.green;
      case 'finance':
      case 'investment':
        return Colors.orange;
      case 'productivity':
      case 'work':
        return Colors.purple;
      case 'wellness':
      case 'health':
        return Colors.teal;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
