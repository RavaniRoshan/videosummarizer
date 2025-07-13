import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/processing_actions_widget.dart';
import './widgets/processing_header_widget.dart';
import './widgets/processing_queue_widget.dart';
import './widgets/processing_stages_widget.dart';
import './widgets/progress_indicator_widget.dart';

class ProcessingStatusScreen extends StatefulWidget {
  const ProcessingStatusScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingStatusScreen> createState() => _ProcessingStatusScreenState();
}

class _ProcessingStatusScreenState extends State<ProcessingStatusScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  // Mock processing data
  final Map<String, dynamic> currentProcessing = {
    "id": "proc_001",
    "videoTitle": "Advanced Flutter State Management Techniques",
    "videoThumbnail":
        "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=225&fit=crop",
    "processingMode": "Presentation Format",
    "progress": 65.0,
    "currentStage": "AI Processing",
    "estimatedTimeRemaining": "2 minutes",
    "startTime": "2025-07-13 06:05:08",
    "stages": [
      {"name": "Video Download", "status": "completed", "icon": "download"},
      {"name": "Content Analysis", "status": "completed", "icon": "analytics"},
      {"name": "AI Processing", "status": "active", "icon": "psychology"},
      {"name": "Summary Generation", "status": "pending", "icon": "description"}
    ]
  };

  final List<Map<String, dynamic>> processingQueue = [
    {
      "id": "proc_002",
      "videoTitle": "Machine Learning Fundamentals",
      "processingMode": "Summary Format",
      "progress": 25.0,
      "status": "queued"
    },
    {
      "id": "proc_003",
      "videoTitle": "React vs Flutter Comparison",
      "processingMode": "Action Plan Format",
      "progress": 0.0,
      "status": "waiting"
    }
  ];

  final List<Map<String, dynamic>> completedProcessing = [
    {
      "id": "proc_completed_001",
      "videoTitle": "Introduction to Dart Programming",
      "processingMode": "Presentation Format",
      "completedAt": "2025-07-13 05:45:08",
      "status": "completed"
    }
  ];

  bool _isExpanded = false;
  bool _showCompletedHistory = false;
  bool _isNetworkConnected = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startProcessingSimulation();
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: currentProcessing["progress"] / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _startProcessingSimulation() {
    // Simulate processing progress updates
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          currentProcessing["progress"] = 80.0;
          currentProcessing["currentStage"] = "Summary Generation";
          currentProcessing["estimatedTimeRemaining"] = "1 minute";
          // Update stages
          (currentProcessing["stages"] as List)[2]["status"] = "completed";
          (currentProcessing["stages"] as List)[3]["status"] = "active";
        });
        _updateProgressAnimation();
      }
    });
  }

  void _updateProgressAnimation() {
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: currentProcessing["progress"] / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _progressController.reset();
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Cancel Processing?',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to cancel the video processing? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep Processing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelProcessing();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _cancelProcessing() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processing cancelled successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  void _retryProcessing() {
    setState(() {
      _isNetworkConnected = true;
      currentProcessing["progress"] = 0.0;
      currentProcessing["currentStage"] = "Video Download";
      currentProcessing["estimatedTimeRemaining"] = "5 minutes";
      // Reset stages
      for (var stage in (currentProcessing["stages"] as List)) {
        stage["status"] =
            stage["name"] == "Video Download" ? "active" : "pending";
      }
    });
    _updateProgressAnimation();
    _startProcessingSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/home-dashboard'),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Processing Status',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showCompletedHistory = !_showCompletedHistory;
              });
            },
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Network Status Warning
              if (!_isNetworkConnected) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'wifi_off',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No Internet Connection',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                            Text(
                              'Processing paused. Will resume when connection is restored.',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _retryProcessing,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ],

              // Processing Header
              ProcessingHeaderWidget(
                videoData: currentProcessing,
              ),

              SizedBox(height: 3.h),

              // Progress Indicator
              ProgressIndicatorWidget(
                progressAnimation: _progressAnimation,
                pulseAnimation: _pulseAnimation,
                currentProcessing: currentProcessing,
                isNetworkConnected: _isNetworkConnected,
              ),

              SizedBox(height: 3.h),

              // Processing Stages
              ProcessingStagesWidget(
                stages: (currentProcessing["stages"] as List)
                    .cast<Map<String, dynamic>>(),
              ),

              SizedBox(height: 3.h),

              // Processing Queue
              if (processingQueue.isNotEmpty) ...[
                ProcessingQueueWidget(
                  queueData: processingQueue,
                  isExpanded: _isExpanded,
                  onToggleExpanded: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
                SizedBox(height: 3.h),
              ],

              // Completed History
              if (_showCompletedHistory && completedProcessing.isNotEmpty) ...[
                Card(
                  child: ExpansionTile(
                    leading: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      'Completed (${completedProcessing.length})',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    children: completedProcessing.map((item) {
                      return ListTile(
                        leading: CustomIconWidget(
                          iconName: 'video_library',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        title: Text(
                          item["videoTitle"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${item["processingMode"]} • Completed ${item["completedAt"]}',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        trailing: CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/summary-view-screen');
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 3.h),
              ],

              // Processing Actions
              ProcessingActionsWidget(
                onCancel: _showCancelConfirmation,
                onNavigateAway: () {
                  Navigator.pushNamed(context, '/home-dashboard');
                },
                isProcessing: currentProcessing["progress"] < 100,
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
