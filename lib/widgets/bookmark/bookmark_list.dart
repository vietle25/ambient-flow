import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../cubits/bookmark/bookmark_cubit.dart';
import '../../models/bookmark_collection.dart';
import '../../models/sound_bookmark.dart';
import '../../navigation/route_constants.dart';
import 'bookmark_list_item.dart';

/// Widget for displaying a list of bookmarks.
class BookmarkList extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onClose;

  const BookmarkList({
    super.key,
    required this.isVisible,
    this.onClose,
  });

  @override
  State<BookmarkList> createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(BookmarkList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Background overlay
        GestureDetector(
          onTap: widget.onClose ??
              () => context.read<BookmarkCubit>().hideBookmarkList(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),

        // Bookmark list panel
        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: 400,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(-5, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bookmarks,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Saved Bookmarks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              context.router
                                  .navigateNamed(RouteConstants.bookmarks);
                              context.read<BookmarkCubit>().hideBookmarkList();
                            },
                            icon: const Icon(Icons.settings,
                                color: Colors.white70),
                            tooltip: 'Manage Bookmarks',
                          ),
                          IconButton(
                            onPressed: widget.onClose ??
                                () => context
                                    .read<BookmarkCubit>()
                                    .hideBookmarkList(),
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    // Bookmark list content
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
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error loading bookmarks',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16,
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
                                      onPressed: () => context
                                          .read<BookmarkCubit>()
                                          .loadBookmarks(),
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
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No bookmarks yet',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Save your favorite sound combinations to access them quickly later.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Display bookmarks
                          final List<SoundBookmark> bookmarks =
                              state.bookmarks.sortedByUpdated;

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: bookmarks.length,
                            itemBuilder: (context, index) {
                              final SoundBookmark bookmark = bookmarks[index];
                              return BookmarkListItem(
                                key: ValueKey(bookmark.id),
                                bookmark: bookmark,
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Footer with bookmark count and limits
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
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white.withOpacity(0.6),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${state.bookmarkCount} of ${BookmarkCollection.maxBookmarks} bookmarks',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
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
          ),
        ),
      ],
    );
  }
}
