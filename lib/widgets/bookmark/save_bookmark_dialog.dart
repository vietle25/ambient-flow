import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/bookmark/bookmark_cubit.dart';

/// Available icons for bookmarks
const List<String> bookmarkIcons = [
  '🎵',
  '🎶',
  '🎼',
  '🎹',
  '🎸',
  '🥁',
  '🎺',
  '🎷',
  '🎻',
  '🎤',
  '🔊',
  '📻',
  '🎧',
  '🎚️',
  '🎛️',
  '💿',
  '📀',
  '💽',
  '📼',
  '🎪',
  '🎭',
  '🎨',
  '🎯',
  '🎲',
  '🎳',
  '🎮',
  '🕹️',
  '🎰',
  '🃏',
  '🀄',
  '🎴',
  '🌟',
  '⭐',
  '✨',
  '💫',
  '🌙',
  '☀️',
  '🌈',
  '🔥',
  '💎',
  '🌸',
  '🌺',
  '🌻',
  '🌷',
  '🌹',
  '🌿',
  '🍀',
  '🌱',
];

/// Dialog for saving a new bookmark
class SaveBookmarkDialog extends StatefulWidget {
  const SaveBookmarkDialog({super.key});

  @override
  State<SaveBookmarkDialog> createState() => _SaveBookmarkDialogState();
}

class _SaveBookmarkDialogState extends State<SaveBookmarkDialog> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  String _selectedIcon = bookmarkIcons[0]; // Default to first icon

  @override
  void initState() {
    super.initState();
    // Set initial values from cubit state
    final BookmarkState state = context.read<BookmarkCubit>().state;
    _nameController.text = state.newBookmarkName;

    // Focus on name field when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocusNode.requestFocus();
      _nameController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _nameController.text.length,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookmarkCubit, BookmarkState>(
      listener: (BuildContext context, BookmarkState state) {
        if (state.status == BookmarkStatus.saved) {
          Navigator.of(context).pop();
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title
              const Text(
                'Save Bookmark',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Icon selection
              const Text(
                'Choose Icon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: bookmarkIcons.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String icon = bookmarkIcons[index];
                    final bool isSelected = icon == _selectedIcon;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white.withOpacity(0.5)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Name field
              TextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter bookmark name',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (String value) {
                  context.read<BookmarkCubit>().updateNewBookmarkName(value);
                },
                onSubmitted: (String _) => _saveBookmark(),
              ),
              const SizedBox(height: 24),

              // Error message
              BlocBuilder<BookmarkCubit, BookmarkState>(
                buildWhen: (BookmarkState previous, BookmarkState current) =>
                    previous.errorMessage != current.errorMessage,
                builder: (BuildContext context, BookmarkState state) {
                  if (state.errorMessage != null) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () =>
                        context.read<BookmarkCubit>().hideSaveDialog(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                  BlocBuilder<BookmarkCubit, BookmarkState>(
                    buildWhen:
                        (BookmarkState previous, BookmarkState current) =>
                            previous.isLoading != current.isLoading ||
                            previous.isNewBookmarkNameValid !=
                                current.isNewBookmarkNameValid,
                    builder: (BuildContext context, BookmarkState state) {
                      return ElevatedButton(
                        onPressed:
                            state.isLoading || !state.isNewBookmarkNameValid
                                ? null
                                : _saveBookmark,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              )
                            : const Text('Save'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBookmark() {
    // Update the cubit with the selected icon
    context.read<BookmarkCubit>().updateNewBookmarkIcon(_selectedIcon);
    context.read<BookmarkCubit>().saveCurrentCombination();
  }
}
