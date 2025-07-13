import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/rich_text_toolbar_widget.dart';
import './widgets/tag_input_widget.dart';
import './widgets/video_context_card_widget.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isKeyboardVisible = false;
  bool _isToolbarExpanded = true;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  bool _isVoiceRecording = false;
  String _saveStatus = 'All changes saved';
  int _characterCount = 0;

  // Rich text formatting states
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isBulletList = false;
  bool _isNumberedList = false;
  double _textSize = 16.0;

  // Undo/Redo functionality
  List<String> _textHistory = [];
  int _historyIndex = -1;

  // Mock video context data
  final Map<String, dynamic> _videoContext = {
    "id": "dQw4w9WgXcQ",
    "title": "Advanced Flutter State Management Techniques",
    "thumbnail":
        "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?fm=jpg&q=60&w=3000",
    "duration": "15:42",
    "timestamp": "3:24",
    "channel": "Flutter Academy"
  };

  // Mock existing tags for autocomplete
  final List<String> _existingTags = [
    "flutter",
    "mobile development",
    "state management",
    "widgets",
    "dart",
    "ui/ux",
    "performance",
    "architecture",
    "tutorial",
    "notes"
  ];

  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _textFocusNode.addListener(_onFocusChanged);

    // Initialize with auto-focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textFocusNode.requestFocus();
    });

    // Add initial state to history
    _addToHistory('');
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _characterCount = _textController.text.length;
      _hasUnsavedChanges = true;
      _saveStatus = 'Saving...';
    });

    // Auto-save simulation
    _simulateAutoSave();
  }

  void _onFocusChanged() {
    setState(() {
      _isKeyboardVisible = _textFocusNode.hasFocus;
    });
  }

  void _addToHistory(String text) {
    if (_historyIndex < _textHistory.length - 1) {
      _textHistory = _textHistory.sublist(0, _historyIndex + 1);
    }
    _textHistory.add(text);
    _historyIndex = _textHistory.length - 1;
  }

  void _simulateAutoSave() {
    setState(() {
      _isSaving = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _hasUnsavedChanges = false;
          _saveStatus = 'All changes saved';
        });
      }
    });
  }

  void _toggleBold() {
    setState(() {
      _isBold = !_isBold;
    });
    _applyFormatting();
  }

  void _toggleItalic() {
    setState(() {
      _isItalic = !_isItalic;
    });
    _applyFormatting();
  }

  void _toggleUnderline() {
    setState(() {
      _isUnderline = !_isUnderline;
    });
    _applyFormatting();
  }

  void _toggleBulletList() {
    setState(() {
      _isBulletList = !_isBulletList;
      if (_isBulletList) _isNumberedList = false;
    });
    _applyListFormatting();
  }

  void _toggleNumberedList() {
    setState(() {
      _isNumberedList = !_isNumberedList;
      if (_isNumberedList) _isBulletList = false;
    });
    _applyListFormatting();
  }

  void _applyFormatting() {
    // Simulate rich text formatting
    HapticFeedback.lightImpact();
  }

  void _applyListFormatting() {
    final text = _textController.text;
    final selection = _textController.selection;

    if (selection.isValid) {
      String newText = text;
      if (_isBulletList) {
        newText = text.replaceRange(selection.start, selection.start, '• ');
      } else if (_isNumberedList) {
        newText = text.replaceRange(selection.start, selection.start, '1. ');
      }

      _textController.text = newText;
      _textController.selection = TextSelection.collapsed(
        offset: selection.start + 2,
      );
    }

    HapticFeedback.lightImpact();
  }

  void _changeTextSize(double size) {
    setState(() {
      _textSize = size;
    });
    HapticFeedback.lightImpact();
  }

  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _textController.text = _textHistory[_historyIndex];
        _textController.selection = TextSelection.collapsed(
          offset: _textController.text.length,
        );
      });
      HapticFeedback.lightImpact();
    }
  }

  void _redo() {
    if (_historyIndex < _textHistory.length - 1) {
      setState(() {
        _historyIndex++;
        _textController.text = _textHistory[_historyIndex];
        _textController.selection = TextSelection.collapsed(
          offset: _textController.text.length,
        );
      });
      HapticFeedback.lightImpact();
    }
  }

  void _startVoiceRecording() {
    setState(() {
      _isVoiceRecording = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate voice recording
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVoiceRecording = false;
        });

        // Simulate transcribed text
        final transcribedText = "This is transcribed text from voice input. ";
        final currentText = _textController.text;
        final selection = _textController.selection;

        final newText = currentText.replaceRange(
          selection.start,
          selection.end,
          transcribedText,
        );

        _textController.text = newText;
        _textController.selection = TextSelection.collapsed(
          offset: selection.start + transcribedText.length,
        );

        _addToHistory(newText);
      }
    });
  }

  void _shareNote() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Export Note',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'text_snippet',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Export as Text'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Export as PDF'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share Note'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    _addToHistory(_textController.text);
    setState(() {
      _hasUnsavedChanges = false;
      _saveStatus = 'Note saved successfully';
    });

    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }

  void _cancelEditing() {
    if (_hasUnsavedChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Unsaved Changes'),
          content:
              Text('You have unsaved changes. Do you want to discard them?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Discard'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: _cancelEditing,
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note Editor',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            Text(
              _saveStatus,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _isSaving
                    ? AppTheme.lightTheme.colorScheme.primary
                    : _hasUnsavedChanges
                        ? AppTheme.warningLight
                        : AppTheme.successLight,
              ),
            ),
          ],
        ),
        actions: [
          if (_isSaving)
            Container(
              margin: EdgeInsets.only(right: 4.w),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          IconButton(
            onPressed: _shareNote,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          TextButton(
            onPressed: _saveNote,
            child: Text(
              'Save',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Context Card
          VideoContextCardWidget(
            videoData: _videoContext,
            onDismiss: () {
              setState(() {
                // Handle video context dismissal
              });
            },
          ),

          // Main Editor Area
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  // Undo/Redo Controls
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _historyIndex > 0 ? _undo : null,
                          icon: CustomIconWidget(
                            iconName: 'undo',
                            color: _historyIndex > 0
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.3),
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: _historyIndex < _textHistory.length - 1
                              ? _redo
                              : null,
                          icon: CustomIconWidget(
                            iconName: 'redo',
                            color: _historyIndex < _textHistory.length - 1
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.3),
                            size: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '\$_characterCount characters',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // Text Editor
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      padding: EdgeInsets.all(4.w),
                      child: TextField(
                        controller: _textController,
                        focusNode: _textFocusNode,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontSize: _textSize,
                          fontWeight:
                              _isBold ? FontWeight.bold : FontWeight.normal,
                          fontStyle:
                              _isItalic ? FontStyle.italic : FontStyle.normal,
                          decoration: _isUnderline
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Start typing your notes here...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (text) {
                          if (text.length % 50 == 0 && text.isNotEmpty) {
                            _addToHistory(text);
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Tag Input
                  TagInputWidget(
                    existingTags: _existingTags,
                    selectedTags: _selectedTags,
                    onTagsChanged: (tags) {
                      setState(() {
                        _selectedTags = tags;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Rich Text Toolbar
          if (_isKeyboardVisible)
            RichTextToolbarWidget(
              isBold: _isBold,
              isItalic: _isItalic,
              isUnderline: _isUnderline,
              isBulletList: _isBulletList,
              isNumberedList: _isNumberedList,
              textSize: _textSize,
              isVoiceRecording: _isVoiceRecording,
              isExpanded: _isToolbarExpanded,
              onToggleBold: _toggleBold,
              onToggleItalic: _toggleItalic,
              onToggleUnderline: _toggleUnderline,
              onToggleBulletList: _toggleBulletList,
              onToggleNumberedList: _toggleNumberedList,
              onTextSizeChanged: _changeTextSize,
              onVoiceRecording: _startVoiceRecording,
              onToggleExpanded: () {
                setState(() {
                  _isToolbarExpanded = !_isToolbarExpanded;
                });
              },
            ),
        ],
      ),
    );
  }
}
