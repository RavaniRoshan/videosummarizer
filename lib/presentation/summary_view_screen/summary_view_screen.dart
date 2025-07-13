import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/export_menu_widget.dart';
import './widgets/note_card_widget.dart';
import './widgets/note_editor_bottom_sheet.dart';
import './widgets/summary_content_widget.dart';

class SummaryViewScreen extends StatefulWidget {
  const SummaryViewScreen({super.key});

  @override
  State<SummaryViewScreen> createState() => _SummaryViewScreenState();
}

class _SummaryViewScreenState extends State<SummaryViewScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isBookmarked = false;
  String _selectedText = '';
  int _currentMode = 0; // 0: Presentation, 1: Summary, 2: Action Plan
  double _readingProgress = 0.0;

  // Mock data for the video summary
  final Map<String, dynamic> _videoData = {
    "id": "video_001",
    "title": "Advanced Flutter State Management Techniques",
    "thumbnail":
        "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=300&fit=crop",
    "duration": "24:35",
    "processingMode": "Presentation",
    "uploadDate": "2025-01-10",
    "channel": "Flutter Academy",
    "views": "125K"
  };

  final List<Map<String, dynamic>> _summaryModes = [
    {
      "title": "Presentation",
      "icon": "slideshow",
      "content": [
        {
          "type": "slide",
          "title": "Introduction to State Management",
          "content":
              "State management is crucial for building scalable Flutter applications. This presentation covers advanced techniques including Provider, Riverpod, and Bloc patterns."
        },
        {
          "type": "slide",
          "title": "Provider Pattern Deep Dive",
          "content":
              "Provider offers a simple yet powerful way to manage state. Key benefits include dependency injection, automatic disposal, and excellent performance optimization."
        },
        {
          "type": "slide",
          "title": "Riverpod Implementation",
          "content":
              "Riverpod addresses Provider limitations with compile-time safety, better testing support, and improved developer experience through code generation."
        }
      ]
    },
    {
      "title": "Summary",
      "icon": "article",
      "content": [
        {
          "type": "paragraph",
          "content":
              "This comprehensive tutorial explores advanced Flutter state management techniques essential for building production-ready applications. The video begins with fundamental concepts before diving into practical implementations of popular state management solutions.\n\nProvider pattern serves as the foundation, offering dependency injection and automatic resource disposal. The presenter demonstrates real-world scenarios where Provider excels, particularly in medium-complexity applications requiring straightforward state sharing between widgets.\n\nRiverpod emerges as the next evolution, addressing Provider's limitations through compile-time safety and enhanced testing capabilities. Code generation features significantly reduce boilerplate while improving developer productivity and application maintainability."
        }
      ]
    },
    {
      "title": "Action Plan",
      "icon": "checklist",
      "content": [
        {
          "type": "action",
          "step": 1,
          "title": "Setup Development Environment",
          "content":
              "Install Flutter SDK 3.10+ and configure your IDE with Flutter extensions",
          "completed": true
        },
        {
          "type": "action",
          "step": 2,
          "title": "Implement Provider Pattern",
          "content":
              "Create a simple counter app using Provider for state management",
          "completed": false
        },
        {
          "type": "action",
          "step": 3,
          "title": "Migrate to Riverpod",
          "content":
              "Refactor the Provider implementation to use Riverpod with code generation",
          "completed": false
        },
        {
          "type": "action",
          "step": 4,
          "title": "Add Testing Suite",
          "content":
              "Write unit and widget tests for your state management implementation",
          "completed": false
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> _personalNotes = [
    {
      "id": "note_001",
      "content":
          "Provider vs Riverpod comparison - Riverpod offers better compile-time safety",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "tags": ["provider", "riverpod", "comparison"],
      "selectedText": "Riverpod addresses Provider limitations"
    },
    {
      "id": "note_002",
      "content":
          "Remember to implement proper disposal in Provider to prevent memory leaks",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 45)),
      "tags": ["provider", "memory", "best-practices"],
      "selectedText": "automatic disposal"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_updateReadingProgress);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _currentMode = _tabController.index;
    });
  }

  void _updateReadingProgress() {
    if (_scrollController.hasClients) {
      final progress =
          _scrollController.offset / _scrollController.position.maxScrollExtent;
      setState(() {
        _readingProgress = progress.clamp(0.0, 1.0);
      });
    }
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _isBookmarked ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showExportMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ExportMenuWidget(
        onExportPdf: () => _exportContent('PDF'),
        onExportText: () => _exportContent('Text'),
        onShare: () => _shareContent(),
      ),
    );
  }

  void _exportContent(String format) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting as $format...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareContent() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening share options...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openNoteEditor({String? selectedText}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteEditorBottomSheet(
        selectedText: selectedText ?? _selectedText,
        onSaveNote: _saveNote,
      ),
    );
  }

  void _saveNote(String content, List<String> tags) {
    final newNote = {
      "id": "note_${DateTime.now().millisecondsSinceEpoch}",
      "content": content,
      "timestamp": DateTime.now(),
      "tags": tags,
      "selectedText": _selectedText
    };

    setState(() {
      _personalNotes.insert(0, newNote);
      _selectedText = '';
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _editNote(String noteId) {
    final note = _personalNotes.firstWhere((n) => n['id'] == noteId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteEditorBottomSheet(
        initialContent: note['content'],
        selectedText: note['selectedText'] ?? '',
        onSaveNote: (content, tags) => _updateNote(noteId, content, tags),
      ),
    );
  }

  void _updateNote(String noteId, String content, List<String> tags) {
    setState(() {
      final noteIndex = _personalNotes.indexWhere((n) => n['id'] == noteId);
      if (noteIndex != -1) {
        _personalNotes[noteIndex]['content'] = content;
        _personalNotes[noteIndex]['tags'] = tags;
        _personalNotes[noteIndex]['timestamp'] = DateTime.now();
      }
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteNote(String noteId) {
    setState(() {
      _personalNotes.removeWhere((n) => n['id'] == noteId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareNote(String noteId) {
    final note = _personalNotes.firstWhere((n) => n['id'] == noteId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing note: ${note['content'].substring(0, 30)}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Summary',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _toggleBookmark,
            icon: CustomIconWidget(
              iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
              color: _isBookmarked
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showExportMenu,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Reading Progress Indicator
          LinearProgressIndicator(
            value: _readingProgress,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary),
          ),

          // Video Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: _videoData['thumbnail'],
                    width: 20.w,
                    height: 12.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _videoData['title'],
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _videoData['duration'],
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          SizedBox(width: 3.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _videoData['processingMode'],
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${_videoData['channel']} • ${_videoData['views']} views',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mode Switching Tabs
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: _summaryModes
                  .map((mode) => Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: mode['icon'],
                              color: _currentMode == _summaryModes.indexOf(mode)
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 18,
                            ),
                            SizedBox(width: 1.w),
                            Text(mode['title']),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Main Content Area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _summaryModes
                  .map((mode) => SingleChildScrollView(
                        controller: _scrollController,
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Summary Content
                            SummaryContentWidget(
                              content: mode['content'],
                              mode: mode['title'],
                              onTextSelected: (text) {
                                setState(() {
                                  _selectedText = text;
                                });
                                HapticFeedback.selectionClick();
                              },
                            ),

                            SizedBox(height: 4.h),

                            // Personal Notes Section
                            if (_personalNotes.isNotEmpty) ...[
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'note',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Personal Notes',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              ..._personalNotes
                                  .map((note) => NoteCardWidget(
                                        note: note,
                                        onEdit: () => _editNote(note['id']),
                                        onDelete: () => _deleteNote(note['id']),
                                        onShare: () => _shareNote(note['id']),
                                      ))
                                  .toList(),
                            ],

                            SizedBox(height: 10.h), // Extra space for FAB
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteEditor(),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }
}
