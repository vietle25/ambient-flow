import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../cubits/bookmark/bookmark_cubit.dart';
import '../../models/bookmark_collection.dart';
import '../../models/sound_bookmark.dart';
import '../../services/di/service_locator.dart';
import '../../widgets/bookmark/bookmark_list_item.dart';

@RoutePage()
class BookmarkManagementPage extends StatefulWidget {
  const BookmarkManagementPage({super.key});

  @override
  State<BookmarkManagementPage> createState() => _BookmarkManagementPageState();
}

class _BookmarkManagementPageState extends State<BookmarkManagementPage> {
  final BookmarkCubit _bookmarkCubit = getIt<BookmarkCubit>();
  String _searchQuery = '';
  BookmarkSortOption _sortOption = BookmarkSortOption.dateCreated;

  @override
  void initState() {
    super.initState();
    _bookmarkCubit.loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bookmarkCubit,
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackground.withOpacity(0.8),
          foregroundColor: Colors.white,
          title: const Text('Bookmark Management'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.router.pop(),
          ),
          actions: [
            // Search button
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchDialog,
            ),
            // Sort button
            PopupMenuButton<BookmarkSortOption>(
              icon: const Icon(Icons.sort),
              onSelected: (BookmarkSortOption option) {
                setState(() {
                  _sortOption = option;
                });
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: BookmarkSortOption.dateCreated,
                  child: Text('Sort by Date Created'),
                ),
                const PopupMenuItem(
                  value: BookmarkSortOption.dateUpdated,
                  child: Text('Sort by Last Updated'),
                ),
                const PopupMenuItem(
                  value: BookmarkSortOption.name,
                  child: Text('Sort by Name'),
                ),
              ],
            ),
            // Export/Import menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: _handleMenuAction,
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download, size: 20),
                      SizedBox(width: 8),
                      Text('Export Bookmarks'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'import',
                  child: Row(
                    children: [
                      Icon(Icons.upload, size: 20),
                      SizedBox(width: 8),
                      Text('Import Bookmarks'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Clear All', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryBackground,
                AppColors.secondaryBackground,
              ],
            ),
          ),
          child: Column(
            children: [
              // Search bar (if search is active)
              if (_searchQuery.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search bookmarks...',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),

              // Bookmark list
              Expanded(
                child: BlocBuilder<BookmarkCubit, BookmarkState>(
                  buildWhen: (previous, current) =>
                      previous.bookmarks != current.bookmarks ||
                      previous.status != current.status,
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }

                    if (state.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading bookmarks',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.errorMessage ?? 'Unknown error',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => _bookmarkCubit.loadBookmarks(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (!state.hasBookmarks) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                color: Colors.white.withOpacity(0.3),
                                size: 80,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No bookmarks yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Create your first bookmark by saving a sound combination from the main screen.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => context.router.pop(),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Go Back'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Filter and sort bookmarks
                    List<SoundBookmark> bookmarks =
                        _getFilteredAndSortedBookmarks(state);

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: bookmarks.length,
                      itemBuilder: (context, index) {
                        final SoundBookmark bookmark = bookmarks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: BookmarkListItem(
                            key: ValueKey(bookmark.id),
                            bookmark: bookmark,
                            onTap: () => _applyBookmarkAndGoBack(bookmark),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Footer with stats
              BlocBuilder<BookmarkCubit, BookmarkState>(
                buildWhen: (previous, current) =>
                    previous.bookmarkCount != current.bookmarkCount,
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.bookmarkCount} bookmark${state.bookmarkCount != 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${BookmarkCollection.maxBookmarks - state.bookmarkCount} remaining',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<SoundBookmark> _getFilteredAndSortedBookmarks(BookmarkState state) {
    List<SoundBookmark> bookmarks = List.from(state.bookmarks.bookmarks);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      bookmarks = bookmarks.where((bookmark) {
        return bookmark.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sort bookmarks
    switch (_sortOption) {
      case BookmarkSortOption.dateCreated:
        bookmarks = state.bookmarks.sortedByDate;
        break;
      case BookmarkSortOption.dateUpdated:
        bookmarks = state.bookmarks.sortedByUpdated;
        break;
      case BookmarkSortOption.name:
        bookmarks = state.bookmarks.sortedByName;
        break;
    }

    return bookmarks;
  }

  void _showSearchDialog() {
    setState(() {
      _searchQuery = ' '; // Trigger search bar visibility
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export':
        _exportBookmarks();
        break;
      case 'import':
        _importBookmarks();
        break;
      case 'clear_all':
        _showClearAllDialog();
        break;
    }
  }

  void _exportBookmarks() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon!'),
      ),
    );
  }

  void _importBookmarks() {
    // TODO: Implement import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Import functionality coming soon!'),
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryBackground.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Clear All Bookmarks',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete all bookmarks? This action cannot be undone.',
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _bookmarkCubit.clearAllBookmarks();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _applyBookmarkAndGoBack(SoundBookmark bookmark) {
    _bookmarkCubit.applyBookmark(bookmark);
    context.router.pop();
  }
}

enum BookmarkSortOption {
  dateCreated,
  dateUpdated,
  name,
}
