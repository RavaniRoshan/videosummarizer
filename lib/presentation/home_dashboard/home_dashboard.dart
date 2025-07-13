import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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
              title: Text(
                'Add Video URL',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      hintText: 'Enter YouTube video URL',
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Choose processing mode:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    'AI Provider:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  child: const Text('Cancel'),
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
      child: Chip(
        label: Text(
          mode,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : null,
          ),
        ),
        backgroundColor: isSelected
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.primaryContainer,
      ),
    );
  }

  Widget _buildProviderChip(
      String provider, String selectedProvider, Function(String) onSelect) {
    final isSelected = provider.toLowerCase() == selectedProvider.toLowerCase();
    return GestureDetector(
      onTap: () => onSelect(provider.toLowerCase()),
      child: Chip(
        label: Text(
          provider,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : null,
          ),
        ),
        backgroundColor: isSelected
            ? AppTheme.lightTheme.colorScheme.secondary
            : AppTheme.lightTheme.colorScheme.secondaryContainer,
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
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 6.w,
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        child: Text(
                          'JD',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning, John!',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Ready to learn something new?',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Open search functionality
                        },
                        icon: CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Summaries Section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Summaries',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/summary-view-screen');
                            },
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: 25.h,
                        child: recentSummaries.isEmpty
                            ? _buildEmptyState('No summaries yet',
                                'Start by adding a YouTube video URL')
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: recentSummaries.length,
                                itemBuilder: (context, index) {
                                  final summary = recentSummaries[index];
                                  return RecentSummaryCardWidget(
                                    summary: summary,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/summary-view-screen');
                                    },
                                    onLongPress: () {
                                      _showSummaryContextMenu(summary);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Personal Notes Section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Personal Notes',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/notes-library-screen');
                            },
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),

              // Personal Notes List
              personalNotes.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        height: 20.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: _buildEmptyState(
                            'No notes yet', 'Create your first note'),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final note = personalNotes[index];
                          return PersonalNoteCardWidget(
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
                          );
                        },
                        childCount:
                            personalNotes.length > 3 ? 3 : personalNotes.length,
                      ),
                    ),

              // Processing Queue Section
              if (processingQueue.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Processing Queue',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ...processingQueue.map((item) => ProcessingQueueWidget(
                              item: item,
                              onCancel: () {
                                // Handle cancel processing
                              },
                            )),
                      ],
                    ),
                  ),
                ),

              // Bottom spacing
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showVideoInputDialog,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'note',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'favorite',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'video_library',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
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
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle share action
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'favorite_border',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: const Text('Add to Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle favorite action
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle delete action
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
