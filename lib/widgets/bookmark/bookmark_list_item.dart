import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../cubits/bookmark/bookmark_cubit.dart';
import '../../models/sound_bookmark.dart';

/// Widget for displaying a single bookmark in a list.
class BookmarkListItem extends StatefulWidget {
  final SoundBookmark bookmark;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BookmarkListItem({
    super.key,
    required this.bookmark,
    this.onTap,
    this.onDelete,
  });

  @override
  State<BookmarkListItem> createState() => _BookmarkListItemState();
}

class _BookmarkListItemState extends State<BookmarkListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: widget.bookmark.isLastUsed
              ? AppColors.categoryButtonSelected.withOpacity(0.3)
              : (_isHovered
                  ? Colors.white.withOpacity(0.1)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.bookmark.isLastUsed
                ? Colors.white.withOpacity(0.3)
                : (_isHovered
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap ?? () => _applyBookmark(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Bookmark icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.bookmark.isLastUsed
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.bookmark.isLastUsed
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Bookmark details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and last used indicator
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.bookmark.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.bookmark.isLastUsed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Last Used',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Sound count and description
                        Row(
                          children: [
                            Icon(
                              Icons.music_note,
                              color: Colors.white.withOpacity(0.7),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.bookmark.soundCount} sound${widget.bookmark.soundCount != 1 ? 's' : ''}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Created date
                        Text(
                          _formatDate(widget.bookmark.createdAt),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons (visible on hover)
                  if (_isHovered) ...[
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Apply button
                        IconButton(
                          onPressed: _applyBookmark,
                          icon: const Icon(Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 20,
                          tooltip: 'Apply bookmark',
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                        // Delete button
                        IconButton(
                          onPressed: widget.onDelete ?? _deleteBookmark,
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red.withOpacity(0.8),
                          iconSize: 20,
                          tooltip: 'Delete bookmark',
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _applyBookmark() {
    context.read<BookmarkCubit>().applyBookmark(widget.bookmark);
  }

  void _deleteBookmark() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryBackground.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Bookmark',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${widget.bookmark.name}"? This action cannot be undone.',
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
                context.read<BookmarkCubit>().deleteBookmark(widget.bookmark);
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
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
