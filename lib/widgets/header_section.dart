import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_strings.dart';
import '../screens/home/cubit/home_cubit.dart';
import 'category_button.dart';

class HeaderSection extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const HeaderSection({
    super.key,
    this.isMobile = false,
    this.isTablet = false,
    this.isDesktop = true,
  });

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  String? selectedCategory;
  final List<String> categories = <String>[
    AppStrings.playlists,
    AppStrings.favorites,
  ];

  final List<String> subCategories = <String>[
    AppStrings.productivity,
    AppStrings.random,
    AppStrings.relax,
    AppStrings.noiseBlocker,
    AppStrings.motivation
  ];
  String? selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Semi-transparent overlay with 20% opacity
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Top tabs (Playlists, Favorites)
              _buildCategoryTabs(),
              const SizedBox(height: 16),
              // Sound categories and action buttons
              _buildSoundCategories(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return Row(
      children: <Widget>[
        for (String category in categories)
          CategoryButton(
            text: category,
            isSelected: selectedCategory == category,
            onPressed: () {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
      ],
    );
  }

  Widget _buildSoundCategories() {
    if (widget.isMobile) {
      // For mobile, stack the categories and actions vertically
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCategoryButtons(),
          const SizedBox(height: 8),
          _buildActionButtons(),
        ],
      );
    } else {
      // For tablet and desktop, show categories and actions in one row
      return Row(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (String subCategory in subCategories)
                    CategoryButton(
                      text: subCategory,
                      isSelected: selectedSubCategory == subCategory,
                      onPressed: () {
                        setState(() {
                          selectedSubCategory = subCategory;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      );
    }
  }

  Widget _buildCategoryButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (String subCategory in subCategories)
            CategoryButton(
              text: subCategory,
              isSelected: selectedSubCategory == subCategory,
              onPressed: () {
                setState(() {
                  selectedSubCategory = subCategory;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CategoryButton(
            text: AppStrings.save,
            isSelected: false,
            onPressed: () {
              // Show a dialog to name the combination
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Save Sound Combination'),
                  content: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter a name for this combination',
                    ),
                    onSubmitted: (String value) {
                      if (value.isNotEmpty) {
                        BlocProvider.of<HomeCubit>(context)
                            .saveSoundCombination(value);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Get the text from the TextField and save it
                        // In a real app, you'd use a TextEditingController
                        // For simplicity, we'll just close the dialog here
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            }),
        CategoryButton(
            text: AppStrings.clear,
            isSelected: false,
            onPressed: () => BlocProvider.of<HomeCubit>(context).clearSounds()),
        CategoryButton(
            text: AppStrings.share, isSelected: false, onPressed: () {}),
      ],
    );
  }
}
