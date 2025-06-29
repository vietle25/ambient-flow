import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_bar/slider_bar.dart';

import '../constants/app_strings.dart';
import '../constants/app_styles.dart';
import '../navigation/route_constants.dart';
import '../screens/home/cubit/home_cubit.dart';
import '../screens/home/cubit/home_state.dart';
import 'auth/login_button.dart';
import 'bookmark/bookmark_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: GestureDetector(
        onTap: () => context.router.navigateNamed(RouteConstants.home),
        child: const Text(AppStrings.appTitle, style: AppStyles.appBarTitle),
      ),
      centerTitle: false,
      actions: <Widget>[
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (HomeState previous, HomeState current) =>
              previous.volume != current.volume ||
              previous.isMuted != current.isMuted,
          builder: (BuildContext context, HomeState state) {
            return Row(
              children: <Widget>[
                // Bookmark controls
                const SaveBookmarkButton(),
                const SizedBox(width: 16),

                // Volume slider - always visible
                SizedBox(
                  width: 120,
                  child: SliderBar(
                    config: SliderConfig(
                      min: 0,
                      max: 100,
                      initialValue: state.volume,
                      direction: SliderDirection.horizontal,
                      trackConfig: TrackConfig(
                        activeColor: Colors.white.withOpacity(0.8),
                        inactiveColor: Colors.grey.shade400.withOpacity(0.5),
                        height: 5,
                        radius: 10,
                      ),
                      thumbConfig: const ThumbConfig(
                        color: Colors.white,
                        width: 12,
                        height: 12,
                        shape: BoxShape.circle,
                        radius: 18,
                        elevation: 2,
                        shadowColor: Colors.black26,
                      ),
                    ),
                    onChanged: (double value) {
                      context.read<HomeCubit>().setAppVolume(value);
                      // If volume is adjusted and was muted, unmute it
                      if (state.isMuted && value > 0) {
                        context.read<HomeCubit>().toggleMute();
                      }
                    },
                  ),
                ),
                // Volume icon - toggles mute/unmute
                IconButton(
                  icon: Icon(
                    state.isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                  tooltip: state.isMuted ? 'Unmute' : 'Mute',
                  onPressed: () {
                    context.read<HomeCubit>().toggleMute();
                  },
                ),
              ],
            );
          },
        ),
        // Login button
        LoginButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
