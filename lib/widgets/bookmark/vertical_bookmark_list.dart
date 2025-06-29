import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/bookmark/bookmark_cubit.dart';
import '../../models/sound_bookmark.dart';
import '../../../services/di/service_locator.dart';
import '../../../state/app_state.dart';

/// Vertical bookmark list widget that displays bookmarks as icons in a sidebar.
class VerticalBookmarkList extends StatelessWidget {
  const VerticalBookmarkList({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      right: 20,
      child: BlocBuilder<BookmarkCubit, BookmarkState>(
        buildWhen: (BookmarkState previous, BookmarkState current) =>
            previous.bookmarks != current.bookmarks ||
            previous.status != current.status ||
            current.status == BookmarkStatus.applied ||
            current.status == BookmarkStatus.deleted ||
            current.status == BookmarkStatus.uiRefreshNeeded,
        builder: (BuildContext context, BookmarkState state) {
          if (!state.hasBookmarks) {
            return const SizedBox.shrink();
          }

          final List<SoundBookmark> bookmarks =
              state.bookmarks.sortedByDate.take(5).toList();

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 80,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: bookmarks.map((SoundBookmark bookmark) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: BookmarkIconItem(bookmark: bookmark),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Individual bookmark icon item with hover tooltip.
class BookmarkIconItem extends StatefulWidget {
  final SoundBookmark bookmark;

  const BookmarkIconItem({
    super.key,
    required this.bookmark,
  });

  @override
  State<BookmarkIconItem> createState() => _BookmarkIconItemState();
}

class _BookmarkIconItemState extends State<BookmarkIconItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final AppState appState = getIt<AppState>();
    final bool isCurrentlyActive = _isBookmarkCurrentlyActive(
      widget.bookmark,
      appState.activeSoundIds ?? {},
    );

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
      },
      child: Tooltip(
        message: widget.bookmark.name,
        waitDuration: const Duration(milliseconds: 500),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main bookmark item
            GestureDetector(
              onTap: () => _applyBookmark(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                width: _isHovered ? 46 : 44,
                height: _isHovered ? 46 : 44,
                decoration: BoxDecoration(
                  color: widget.bookmark.isLastUsed
                      ? Colors.white.withOpacity(0.3)
                      : (_isHovered
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCurrentlyActive
                        ? const Color(0xFF4FC3F7)
                        : (widget.bookmark.isLastUsed
                            ? Colors.white.withOpacity(0.5)
                            : (_isHovered
                                ? Colors.white.withOpacity(0.3)
                                : Colors.transparent)),
                    width: isCurrentlyActive ? 2.5 : 2,
                  ),
                  boxShadow: isCurrentlyActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4FC3F7).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 0),
                            spreadRadius: 1,
                          ),
                        ]
                      : (_isHovered
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: isCurrentlyActive ? 22 : 20,
                      color: isCurrentlyActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.9),
                    ),
                    child: Text(widget.bookmark.icon),
                  ),
                ),
              ),
            ),

            // Close button (visible on hover, positioned outside the border)
            if (_isHovered)
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: () => _deleteBookmark(),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _applyBookmark() {
    context.read<BookmarkCubit>().applyBookmark(widget.bookmark);
  }

  void _deleteBookmark() {
    final BookmarkCubit bookmarkCubit = context.read<BookmarkCubit>();

    // Show confirmation dialog before deleting
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider<BookmarkCubit>.value(
          value: bookmarkCubit,
          child: AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Delete Bookmark',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to delete "${widget.bookmark.name}"?',
              style: const TextStyle(color: Colors.white70),
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
                  bookmarkCubit.deleteBookmark(widget.bookmark);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Extension to check if a bookmark is currently active
bool _isBookmarkCurrentlyActive(
    SoundBookmark bookmark, Set<String> activeSoundIds) {
  if (bookmark.sounds.isEmpty || activeSoundIds.isEmpty) {
    return false;
  }

  // Check if all bookmark sounds are currently active
  for (final soundItem in bookmark.sounds) {
    if (!activeSoundIds.contains(soundItem.soundId)) {
      return false;
    }
  }

  // Also check that no extra sounds are playing (exact match)
  return activeSoundIds.length == bookmark.sounds.length;
}
