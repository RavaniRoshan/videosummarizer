import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TagInputWidget extends StatefulWidget {
  final List<String> existingTags;
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;

  const TagInputWidget({
    Key? key,
    required this.existingTags,
    required this.selectedTags,
    required this.onTagsChanged,
  }) : super(key: key);

  @override
  State<TagInputWidget> createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _tagFocusNode = FocusNode();
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _tagController.addListener(_onTagInputChanged);
    _tagFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _tagController.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  void _onTagInputChanged() {
    final input = _tagController.text.toLowerCase();

    if (input.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    final suggestions = widget.existingTags
        .where((tag) =>
            tag.toLowerCase().contains(input) &&
            !widget.selectedTags.contains(tag))
        .take(5)
        .toList();

    setState(() {
      _filteredSuggestions = suggestions;
      _showSuggestions = suggestions.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    if (!_tagFocusNode.hasFocus) {
      setState(() {
        _showSuggestions = false;
      });
    } else {
      _onTagInputChanged();
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !widget.selectedTags.contains(tag)) {
      final updatedTags = List<String>.from(widget.selectedTags)..add(tag);
      widget.onTagsChanged(updatedTags);
      _tagController.clear();
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _removeTag(String tag) {
    final updatedTags = List<String>.from(widget.selectedTags)..remove(tag);
    widget.onTagsChanged(updatedTags);
  }

  void _onSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      _addTag(value.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Tags Display
        if (widget.selectedTags.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children:
                  widget.selectedTags.map((tag) => _buildTagChip(tag)).toList(),
            ),
          ),
          SizedBox(height: 2.h),
        ],

        // Tag Input Field
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _tagFocusNode.hasFocus
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  width: _tagFocusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: _tagController,
                focusNode: _tagFocusNode,
                decoration: InputDecoration(
                  hintText: 'Add tags (press Enter to add)',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'local_offer',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                  suffixIcon: _tagController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () => _addTag(_tagController.text.trim()),
                          icon: CustomIconWidget(
                            iconName: 'add',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 3.h,
                  ),
                ),
                onSubmitted: _onSubmitted,
                textInputAction: TextInputAction.done,
              ),
            ),

            // Suggestions Dropdown
            if (_showSuggestions && _filteredSuggestions.isNotEmpty)
              Positioned(
                top: 100.w,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 30.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _filteredSuggestions.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                      ),
                      itemBuilder: (context, index) {
                        final suggestion = _filteredSuggestions[index];
                        return ListTile(
                          dense: true,
                          leading: CustomIconWidget(
                            iconName: 'local_offer',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          title: Text(
                            suggestion,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          onTap: () => _addTag(suggestion),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Tag Input Helper Text
        if (widget.selectedTags.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h, left: 1.w),
            child: Text(
              'Add tags to organize your notes',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.w, top: 1.h, bottom: 1.h),
            child: Text(
              tag,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _removeTag(tag),
            child: Container(
              padding: EdgeInsets.all(1.w),
              margin: EdgeInsets.only(left: 1.w, right: 1.w),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
