import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteEditorBottomSheet extends StatefulWidget {
  final String? initialContent;
  final String selectedText;
  final Function(String content, List<String> tags) onSaveNote;

  const NoteEditorBottomSheet({
    super.key,
    this.initialContent,
    required this.selectedText,
    required this.onSaveNote,
  });

  @override
  State<NoteEditorBottomSheet> createState() => _NoteEditorBottomSheetState();
}

class _NoteEditorBottomSheetState extends State<NoteEditorBottomSheet> {
  late TextEditingController _contentController;
  late TextEditingController _tagController;
  final FocusNode _contentFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();

  List<String> _tags = [];
  bool _isBold = false;
  bool _isItalic = false;
  bool _isBulletList = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.initialContent ??
          (widget.selectedText.isNotEmpty
              ? 'Re: "${widget.selectedText}"\n\n'
              : ''),
    );
    _tagController = TextEditingController();

    // Auto-focus content field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tagController.dispose();
    _contentFocusNode.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _toggleVoiceInput() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Simulate voice input
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isListening = false;
            _contentController.text += ' Voice input simulated text.';
          });
        }
      });
    }
  }

  void _applyFormatting(String format) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid && !selection.isCollapsed) {
      final selectedText = text.substring(selection.start, selection.end);
      String formattedText = selectedText;

      switch (format) {
        case 'bold':
          formattedText = '**$selectedText**';
          break;
        case 'italic':
          formattedText = '*$selectedText*';
          break;
        case 'bullet':
          formattedText = '• $selectedText';
          break;
      }

      final newText =
          text.replaceRange(selection.start, selection.end, formattedText);
      _contentController.text = newText;
      _contentController.selection = TextSelection.collapsed(
        offset: selection.start + formattedText.length,
      );
    }
  }

  void _saveNote() {
    final content = _contentController.text.trim();
    if (content.isNotEmpty) {
      widget.onSaveNote(content, _tags);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  widget.initialContent != null ? 'Edit Note' : 'New Note',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                SizedBox(width: 2.w),
                ElevatedButton(
                  onPressed: _saveNote,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Selected text reference (if any)
          if (widget.selectedText.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.all(4.w),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'format_quote',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Referenced Text:',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.selectedText,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Formatting toolbar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _applyFormatting('bold'),
                  icon: CustomIconWidget(
                    iconName: 'format_bold',
                    color: _isBold
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () => _applyFormatting('italic'),
                  icon: CustomIconWidget(
                    iconName: 'format_italic',
                    color: _isItalic
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () => _applyFormatting('bullet'),
                  icon: CustomIconWidget(
                    iconName: 'format_list_bulleted',
                    color: _isBulletList
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _toggleVoiceInput,
                  icon: CustomIconWidget(
                    iconName: _isListening ? 'mic' : 'mic_none',
                    color: _isListening
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Content editor
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: TextField(
                controller: _contentController,
                focusNode: _contentFocusNode,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
            ),
          ),

          // Tags section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        focusNode: _tagFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'Add tags...',
                          prefixIcon: Icon(Icons.tag),
                        ),
                        onSubmitted: (_) => _addTag(),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    ElevatedButton(
                      onPressed: _addTag,
                      child: const Text('Add'),
                    ),
                  ],
                ),
                if (_tags.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _tags
                        .map((tag) => Chip(
                              label: Text('#$tag'),
                              onDeleted: () => _removeTag(tag),
                              deleteIcon: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
