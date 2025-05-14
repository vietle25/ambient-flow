import 'package:ambientflow/data/sound_data.dart';
import 'package:ambientflow/models/sound_model.dart';
import 'package:colossus_flutter_common/base/base.dart';
import 'package:flutter/material.dart';

import 'audio_button/audio_button_widget.dart';

class MainContentSection extends CommonPage {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const MainContentSection({
    super.key,
    this.isMobile = false,
    this.isTablet = false,
    this.isDesktop = true,
  });

  @override
  State<MainContentSection> createState() => _MainContentSectionState();

  @override
  // TODO: implement routeSettings
  RouteSettings get routeSettings => throw UnimplementedError();
}

class _MainContentSectionState extends CommonPageState<MainContentSection> {
  @override
  Widget body(BuildContext context) {
    logD('Build MainContentSection');
    // Determine grid columns based on screen size
    int crossAxisCount = 4; // More columns for desktop

    if (widget.isMobile) {
      crossAxisCount = 2;
    } else if (widget.isTablet) {
      crossAxisCount = 3;
    }

    // Calculate the max width based on screen size
    // For desktop, we want it to take up only 50% of the screen width
    double maxWidth = MediaQuery.of(context).size.width;
    if (widget.isDesktop) {
      maxWidth = maxWidth * 0.6;
    } else if (widget.isTablet) {
      maxWidth = maxWidth * 0.8;
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: maxWidth / 2.5,
          vertical: kToolbarHeight + 40,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: widget.isMobile ? 12 : 16,
          crossAxisSpacing: widget.isMobile ? 12 : 16,
          childAspectRatio: 1.0, // Square aspect ratio for buttons
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: SoundData.sounds.length,
        itemBuilder: (BuildContext context, int index) {
          final SoundModel sound = SoundData.sounds[index];
          return AudioButtonWidget(
            key: ValueKey<String>(sound.id),
            sound: sound,
          );
        },
        addAutomaticKeepAlives: true,
      ),
    );
  }
}
