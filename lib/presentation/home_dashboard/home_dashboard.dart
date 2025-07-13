import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/personal_note_card_widget.dart';
import './widgets/processing_queue_widget.dart';
import './widgets/recent_summary_card_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  // Mock data for recent summaries
  final List<Map<String, dynamic>> recentSummaries = [
    {
      "id": 1,
      "title": "Flutter State Management Best Practices",
      "thumbnail":
          "https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=300&h=200&fit=crop",
      "duration": "15:42",
      "mode": "Summary",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "progress": 100,
    },
    {
      "id": 2,
      "title": "Advanced Dart Programming Techniques",
      "thumbnail":
          "https://images.pexels.com/photos/270348/pexels-photo-270348.jpeg?w=300&h=200&fit=crop",
      "duration": "22:15",
      "mode": "Presentation",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "progress": 100,
    },
    {
      "id": 3,
      "title": "Mobile App Design Principles",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/11/29/06/15/plans-1867745_1280.jpg?w=300&h=200&fit=crop",
      "duration": "18:30",
      "mode": "Action Plan",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "progress": 100,
    },
  ];

  // Mock data for personal notes
  final List<Map<String, dynamic>> personalNotes = [
    {
      "id": 1,
      "title": "Key Takeaways from Flutter Tutorial",
      "snippet":
          "Remember to use StatefulWidget for dynamic content and always dispose controllers properly...",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
      "tags": ["flutter", "tutorial"],
    },
    {
      "id": 2,
      "title": "Meeting Notes - Project Planning",
      "snippet":
          "Discussed timeline for mobile app development. Need to focus on user experience and performance optimization...",
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
      "tags": ["meeting", "planning"],
    },
    {
      "id": 3,
      "title": "Research Notes - UI/UX Trends",
      "snippet":
          "Current trends include minimalist design, dark mode support, and micro-interactions for better user engagement...",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "tags": ["research", "ui/ux"],
    },
  ];

  // Mock data for processing queue
  final List<Map<String, dynamic>> processingQueue = [
    {
      "id": 1,
      "title": "React Native vs Flutter Comparison",
      "progress": 65,
      "estimatedTime": "3 min remaining",
    },
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showVideoInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController urlController = TextEditingController();
        String selectedMode = 'Summary';
        String selectedProvider = 'mock';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              title: Text(
                'Add Video URL',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: urlController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Enter YouTube video URL',
                      prefixIcon: Icon(
                        Icons.link,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Processing mode',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    children: [
                      _buildModeChip('Summary', selectedMode, (mode) {
                        setState(() => selectedMode = mode);
                      }),
                      _buildModeChip('Presentation', selectedMode, (mode) {
                        setState(() => selectedMode = mode);
                      }),
                      _buildModeChip('Action Plan', selectedMode, (mode) {
                        setState(() => selectedMode = mode);
                      }),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'AI Provider',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    children: [
                      _buildProviderChip('Mock', selectedProvider, (provider) {
                        setState(() => selectedProvider = provider);
                      }),
                      _buildProviderChip('Gemini', selectedProvider,
                          (provider) {
                        setState(() => selectedProvider = provider);
                      }),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                      context,
                      '/processing-status-screen',
                      arguments: {
                        'url': urlController.text,
                        'mode': selectedMode,
                        'provider': selectedProvider,
                      },
                    );
                  },
                  child: const Text('Process'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildModeChip(
      String mode, String selectedMode, Function(String) onSelect) {
    final isSelected = mode == selectedMode;
    return GestureDetector(
      onTap: () => onSelect(mode),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          mode,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }

  Widget _buildProviderChip(
      String provider, String selectedProvider, Function(String) onSelect) {
    final isSelected = provider.toLowerCase() == selectedProvider.toLowerCase();
    return GestureDetector(
      onTap: () => onSelect(provider.toLowerCase()),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          provider,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/notes-library-screen');
        break;
      case 2:
        // Navigate to favorites (not implemented in this screen)
        break;
      case 3:
        // Navigate to profile (not implemented in this screen)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Theme.of(context).colorScheme.primary,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Notion-style Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                'JD',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Good morning, John',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Ready to learn something new?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Summaries Section - Notion style
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Summaries',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/summary-view-screen');
                            },
                            child: Text(
                              'View all',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        height: 22.h,
                        child: recentSummaries.isEmpty
                            ? _buildEmptyState('No summaries yet',
                                'Start by adding a YouTube video URL')
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(left: 1.w),
                                itemCount: recentSummaries.length,
                                itemBuilder: (context, index) {
                                  final summary = recentSummaries[index];
                                  return Container(
                                    width: 75.w,
                                    margin: EdgeInsets.only(right: 4.w),
                                    child: RecentSummaryCardWidget(
                                      summary: summary,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/summary-view-screen');
                                      },
                                      onLongPress: () {
                                        _showSummaryContextMenu(summary);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Personal Notes Section - Notion style
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Personal Notes',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/notes-library-screen');
                            },
                            child: Text(
                              'View all',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),

              // Personal Notes List - Notion style cards
              personalNotes.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        height: 20.h,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        child: _buildEmptyState(
                            'No notes yet', 'Create your first note'),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final note = personalNotes[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 0.75.h,
                            ),
                            child: PersonalNoteCardWidget(
                              note: note,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/note-editor-screen');
                              },
                              onEdit: () {
                                Navigator.pushNamed(
                                    context, '/note-editor-screen');
                              },
                              onArchive: () {
                                // Handle archive action
                              },
                              onTag: () {
                                // Handle tag action
                              },
                            ),
                          );
                        },
                        childCount:
                            personalNotes.length > 3 ? 3 : personalNotes.length,
                      ),
                    ),

              // Processing Queue Section - Notion style
              if (processingQueue.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Processing Queue',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        ...processingQueue.map((item) => Container(
                              margin: EdgeInsets.only(bottom: 1.h),
                              child: ProcessingQueueWidget(
                                item: item,
                                onCancel: () {
                                  // Handle cancel processing
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

              // Bottom spacing
              SliverToBoxAdapter(
                child: SizedBox(height: 12.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showVideoInputDialog,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                size: 22,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 1 ? Icons.note : Icons.note_outlined,
                size: 22,
              ),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2 ? Icons.favorite : Icons.favorite_border,
                size: 22,
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 3 ? Icons.person : Icons.person_outline,
                size: 22,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.video_library_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 32,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _showVideoInputDialog,
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  void _showSummaryContextMenu(Map<String, dynamic> summary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: Icon(
                  Icons.share_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
                title: Text(
                  'Share',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle share action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite_border,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
                title: Text(
                  'Add to Favorites',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle favorite action
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                title: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle delete action
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
