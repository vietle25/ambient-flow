import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/bookmark/bookmark_cubit.dart';
import '../../models/sound_bookmark.dart';
import '../../services/di/service_locator.dart';
import '../../state/app_state.dart';

/// Button widget for bookmark actions in the app bar.
class BookmarkButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool showBadge;
  final String? badgeText;

  const BookmarkButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.showBadge = false,
    this.badgeText,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main button
                IconButton(
                  onPressed: widget.onPressed,
                  tooltip: widget.tooltip,
                  icon: Icon(
                    widget.icon,
                    color: _isHovered
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                  ),
                ),

                // Badge
                if (widget.showBadge)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: widget.badgeText != null
                          ? Text(
                              widget.badgeText!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Save bookmark button widget.
class SaveBookmarkButton extends StatelessWidget {
  const SaveBookmarkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.status != current.status,
      builder: (context, state) {
        final AppState appState = getIt<AppState>();

        // Check if any bookmark is currently active
        bool isAnyBookmarkActive = false;
        if (state.hasBookmarks &&
            appState.activeSoundIds != null &&
            appState.activeSoundIds!.isNotEmpty) {
          for (final bookmark in state.bookmarks.bookmarks) {
            if (_isBookmarkActive(bookmark, appState.activeSoundIds!)) {
              isAnyBookmarkActive = true;
              break;
            }
          }
        }

        final bool isDisabled = state.isLoading || isAnyBookmarkActive;

        return BookmarkButton(
          icon: state.isLoading
              ? Icons.hourglass_empty
              : (isAnyBookmarkActive
                  ? Icons.bookmark_add_outlined
                  : Icons.bookmark_add),
          tooltip: isAnyBookmarkActive
              ? 'Cannot save while bookmark is active'
              : 'Save current sound combination',
          onPressed: isDisabled
              ? () {} // Disabled when loading or bookmark active
              : () => context.read<BookmarkCubit>().showSaveDialog(),
        );
      },
    );
  }

  /// Helper method to check if a bookmark is currently active
  bool _isBookmarkActive(SoundBookmark bookmark, Set<String> activeSoundIds) {
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
}

/// Bookmark list button widget.
class BookmarkListButton extends StatelessWidget {
  const BookmarkListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      buildWhen: (previous, current) =>
          previous.bookmarkCount != current.bookmarkCount ||
          previous.showBookmarkList != current.showBookmarkList,
      builder: (context, state) {
        return BookmarkButton(
          icon: state.showBookmarkList
              ? Icons.bookmarks
              : Icons.bookmarks_outlined,
          tooltip: 'View saved bookmarks',
          showBadge: state.bookmarkCount > 0,
          badgeText:
              state.bookmarkCount > 9 ? '9+' : state.bookmarkCount.toString(),
          onPressed: () => context.read<BookmarkCubit>().toggleBookmarkList(),
        );
      },
    );
  }
}

/// Quick restore button widget (for last used bookmark).
class QuickRestoreButton extends StatelessWidget {
  const QuickRestoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      buildWhen: (previous, current) =>
          previous.bookmarks != current.bookmarks ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        final lastUsedBookmark = state.bookmarks.getLastUsedBookmark();

        if (lastUsedBookmark == null) {
          return const SizedBox.shrink();
        }

        return BookmarkButton(
          icon: state.isLoading ? Icons.hourglass_empty : Icons.restore,
          tooltip: 'Restore "${lastUsedBookmark.name}"',
          onPressed: state.isLoading
              ? () {} // Disabled when loading
              : () =>
                  context.read<BookmarkCubit>().applyBookmark(lastUsedBookmark),
        );
      },
    );
  }
}
