import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/note_card_widget.dart';
import './widgets/search_bar_widget.dart';

class NotesLibraryScreen extends StatefulWidget {
  const NotesLibraryScreen({Key? key}) : super(key: key);

  @override
  State<NotesLibraryScreen> createState() => _NotesLibraryScreenState();
}

class _NotesLibraryScreenState extends State<NotesLibraryScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = false;
  bool _isSearching = false;
  String _selectedSort = 'Recent';
  List<String> _selectedTags = [];
  bool _isSelectionMode = false;
  List<int> _selectedNotes = [];

  final List<Map<String, dynamic>> _mockNotes = [
    {
      "id": 1,
      "title": "Machine Learning Fundamentals",
      "content":
          "Key concepts from Andrew Ng's course: supervised learning involves training algorithms on labeled data to make predictions...",
      "snippet":
          "Key concepts from Andrew Ng's course: supervised learning involves training algorithms...",
      "videoTitle": "Machine Learning Course - Lecture 1",
      "videoThumbnail":
          "https://images.pexels.com/photos/8386440/pexels-photo-8386440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "tags": ["ML", "Education", "Important"],
      "isFavorite": true,
      "duration": "45:30",
      "noteType": "Summary"
    },
    {
      "id": 2,
      "title": "Flutter State Management",
      "content":
          "Comparison between Provider, Riverpod, and Bloc patterns. Provider is simpler for basic state management...",
      "snippet":
          "Comparison between Provider, Riverpod, and Bloc patterns. Provider is simpler...",
      "videoTitle": "Flutter State Management Deep Dive",
      "videoThumbnail":
          "https://images.pexels.com/photos/11035380/pexels-photo-11035380.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "tags": ["Flutter", "Development", "State"],
      "isFavorite": false,
      "duration": "32:15",
      "noteType": "Technical"
    },
    {
      "id": 3,
      "title": "Investment Strategies",
      "content":
          "Warren Buffett's approach to value investing: look for companies with strong fundamentals, competitive moats...",
      "snippet":
          "Warren Buffett's approach to value investing: look for companies with strong...",
      "videoTitle": "Warren Buffett Investment Philosophy",
      "videoThumbnail":
          "https://images.pexels.com/photos/6801648/pexels-photo-6801648.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "tags": ["Finance", "Investment", "Strategy"],
      "isFavorite": true,
      "duration": "28:45",
      "noteType": "Business"
    },
    {
      "id": 4,
      "title": "Productivity Techniques",
      "content":
          "Time blocking method: allocate specific time slots for different activities. Pomodoro technique for focused work sessions...",
      "snippet":
          "Time blocking method: allocate specific time slots for different activities...",
      "videoTitle": "Productivity Hacks for Professionals",
      "videoThumbnail":
          "https://images.pexels.com/photos/6224/hands-people-woman-working.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "tags": ["Productivity", "Time Management", "Work"],
      "isFavorite": false,
      "duration": "22:30",
      "noteType": "Personal"
    },
    {
      "id": 5,
      "title": "React Hooks Explained",
      "content":
          "useState and useEffect are the most commonly used hooks. useState manages component state while useEffect handles side effects...",
      "snippet":
          "useState and useEffect are the most commonly used hooks. useState manages...",
      "videoTitle": "React Hooks Complete Guide",
      "videoThumbnail":
          "https://images.pexels.com/photos/11035471/pexels-photo-11035471.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(days: 4)),
      "tags": ["React", "JavaScript", "Frontend"],
      "isFavorite": false,
      "duration": "38:20",
      "noteType": "Technical"
    },
    {
      "id": 6,
      "title": "Mindfulness Meditation",
      "content":
          "Daily meditation practice: start with 5 minutes of focused breathing. Observe thoughts without judgment...",
      "snippet":
          "Daily meditation practice: start with 5 minutes of focused breathing...",
      "videoTitle": "Mindfulness for Beginners",
      "videoThumbnail":
          "https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(days: 5)),
      "tags": ["Wellness", "Meditation", "Health"],
      "isFavorite": true,
      "duration": "15:45",
      "noteType": "Personal"
    }
  ];

  List<Map<String, dynamic>> _filteredNotes = [];
  List<String> _searchHistory = [
    "machine learning",
    "flutter state",
    "investment tips",
    "productivity"
  ];

  @override
  void initState() {
    super.initState();
    _filteredNotes = List.from(_mockNotes);
    _sortNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sortNotes() {
    switch (_selectedSort) {
      case 'Recent':
        _filteredNotes.sort((a, b) =>
            (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
        break;
      case 'Alphabetical':
        _filteredNotes.sort(
            (a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
      case 'Video':
        _filteredNotes.sort((a, b) =>
            (a['videoTitle'] as String).compareTo(b['videoTitle'] as String));
        break;
      case 'Tags':
        _filteredNotes.sort((a, b) =>
            (a['tags'] as List).first.compareTo((b['tags'] as List).first));
        break;
    }
    setState(() {});
  }

  void _searchNotes(String query) {
    if (query.isEmpty) {
      _filteredNotes = List.from(_mockNotes);
    } else {
      _filteredNotes = _mockNotes.where((note) {
        final title = (note['title'] as String).toLowerCase();
        final content = (note['content'] as String).toLowerCase();
        final tags = (note['tags'] as List).join(' ').toLowerCase();
        final videoTitle = (note['videoTitle'] as String).toLowerCase();
        final searchQuery = query.toLowerCase();

        return title.contains(searchQuery) ||
            content.contains(searchQuery) ||
            tags.contains(searchQuery) ||
            videoTitle.contains(searchQuery);
      }).toList();
    }
    _sortNotes();
  }

  void _toggleFavorite(int noteId) {
    final noteIndex = _mockNotes.indexWhere((note) => note['id'] == noteId);
    if (noteIndex != -1) {
      setState(() {
        _mockNotes[noteIndex]['isFavorite'] =
            !(_mockNotes[noteIndex]['isFavorite'] as bool);
      });
      _searchNotes(_searchController.text);
    }
  }

  void _deleteNote(int noteId) {
    setState(() {
      _mockNotes.removeWhere((note) => note['id'] == noteId);
      _filteredNotes.removeWhere((note) => note['id'] == noteId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo functionality would restore the note
          },
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedTags: _selectedTags,
        onTagsChanged: (tags) {
          setState(() {
            _selectedTags = tags;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _applyFilters() {
    if (_selectedTags.isEmpty) {
      _filteredNotes = List.from(_mockNotes);
    } else {
      _filteredNotes = _mockNotes.where((note) {
        final noteTags = note['tags'] as List<String>;
        return _selectedTags.any((tag) => noteTags.contains(tag));
      }).toList();
    }
    _sortNotes();
  }

  void _toggleSelectionMode(int? noteId) {
    setState(() {
      if (_isSelectionMode) {
        if (noteId != null) {
          if (_selectedNotes.contains(noteId)) {
            _selectedNotes.remove(noteId);
          } else {
            _selectedNotes.add(noteId);
          }
        }
        if (_selectedNotes.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _isSelectionMode = true;
        if (noteId != null) {
          _selectedNotes.add(noteId);
        }
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedNotes.clear();
    });
  }

  void _bulkDelete() {
    setState(() {
      _mockNotes.removeWhere((note) => _selectedNotes.contains(note['id']));
      _filteredNotes.removeWhere((note) => _selectedNotes.contains(note['id']));
      _selectedNotes.clear();
      _isSelectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected notes deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _isSelectionMode ? _buildSelectionAppBar() : _buildNormalAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            _filteredNotes = List.from(_mockNotes);
          });
          _sortNotes();
        },
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            if (!_isSelectionMode) _buildSearchSection(),
            if (!_isSelectionMode) _buildSortAndViewToggle(),
            Expanded(
              child: _filteredNotes.isEmpty
                  ? _buildEmptyState()
                  : _buildNotesContent(),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _isSelectionMode ? null : _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      title: Text(
        'Notes Library',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onSurface,
          size: 22,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Theme.of(context).colorScheme.onSurface,
            size: 22,
          ),
        ),
        IconButton(
          onPressed: _showFilterBottomSheet,
          icon: Icon(
            Icons.filter_list,
            color: Theme.of(context).colorScheme.onSurface,
            size: 22,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  PreferredSizeWidget _buildSelectionAppBar() {
    return AppBar(
      title: Text(
        '${_selectedNotes.length} selected',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      leading: IconButton(
        onPressed: _exitSelectionMode,
        icon: Icon(
          Icons.close,
          color: Colors.white,
          size: 22,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _selectedNotes.isNotEmpty ? _bulkDelete : null,
          icon: Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 22,
          ),
        ),
        IconButton(
          onPressed: _selectedNotes.isNotEmpty
              ? () {
                  // Bulk export functionality
                }
              : null,
          icon: Icon(
            Icons.share,
            color: Colors.white,
            size: 22,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildSearchSection() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isSearching ? 12.h : 0,
      child: _isSearching
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: _searchNotes,
                searchHistory: _searchHistory,
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildSortAndViewToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortButton(),
                  SizedBox(width: 3.w),
                  if (_selectedTags.isNotEmpty) ..._buildSelectedTagChips(),
                ],
              ),
            ),
          ),
          _buildViewToggle(),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _selectedSort = value;
        });
        _sortNotes();
      },
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sort,
              color: Theme.of(context).colorScheme.onSurface,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              _selectedSort,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(width: 1.w),
            Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.onSurface,
              size: 16,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        'Recent',
        'Alphabetical',
        'Video',
        'Tags',
      ]
          .map((sort) => PopupMenuItem(
                value: sort,
                child: Text(
                  sort,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ))
          .toList(),
    );
  }

  List<Widget> _buildSelectedTagChips() {
    return _selectedTags
        .map((tag) => Container(
              margin: EdgeInsets.only(right: 2.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(width: 1.w),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTags.remove(tag);
                        });
                        _applyFilters();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewToggleButton(false, Icons.view_list),
          _buildViewToggleButton(true, Icons.grid_view),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton(bool isGrid, IconData icon) {
    final isSelected = _isGridView == isGrid;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isGridView = isGrid;
        });
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildNotesContent() {
    return _isGridView ? _buildGridView() : _buildListView();
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        final note = _filteredNotes[index];
        return Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          child: NoteCardWidget(
            note: note,
            isSelected: _selectedNotes.contains(note['id']),
            isSelectionMode: _isSelectionMode,
            onTap: () {
              if (_isSelectionMode) {
                _toggleSelectionMode(note['id'] as int);
              } else {
                Navigator.pushNamed(context, '/note-editor-screen');
              }
            },
            onLongPress: () {
              _toggleSelectionMode(note['id'] as int);
            },
            onFavoriteToggle: () => _toggleFavorite(note['id'] as int),
            onDelete: () => _deleteNote(note['id'] as int),
            onTagTap: (tag) {
              if (!_selectedTags.contains(tag)) {
                setState(() {
                  _selectedTags.add(tag);
                });
                _applyFilters();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        final note = _filteredNotes[index];
        return NoteCardWidget(
          note: note,
          isSelected: _selectedNotes.contains(note['id']),
          isSelectionMode: _isSelectionMode,
          isGridView: true,
          onTap: () {
            if (_isSelectionMode) {
              _toggleSelectionMode(note['id'] as int);
            } else {
              Navigator.pushNamed(context, '/note-editor-screen');
            }
          },
          onLongPress: () {
            _toggleSelectionMode(note['id'] as int);
          },
          onFavoriteToggle: () => _toggleFavorite(note['id'] as int),
          onDelete: () => _deleteNote(note['id'] as int),
          onTagTap: (tag) {
            if (!_selectedTags.contains(tag)) {
              setState(() {
                _selectedTags.add(tag);
              });
              _applyFilters();
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.note_add_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 40,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'No notes found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first note or adjust your filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/note-editor-screen');
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
            label: Text('Create Note'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
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
        onPressed: () {
          Navigator.pushNamed(context, '/note-editor-screen');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
