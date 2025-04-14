import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_styles.dart';
import '../navigation/route_constants.dart';
import '../screens/home/cubit/home_cubit.dart';
import '../screens/home/cubit/home_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(AppStrings.appTitle, style: AppStyles.appBarTitle),
      centerTitle: false,
      actions: <Widget>[
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (HomeState previous, HomeState current) =>
              previous.isPlaying != current.isPlaying ||
              previous.timerRemaining != current.timerRemaining,
          builder: (BuildContext context, HomeState state) {
            return GestureDetector(
              onTap: () => BlocProvider.of<HomeCubit>(context).toggleTimer(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(state.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                        '${(state.timerRemaining ~/ 60).toString().padLeft(2, '0')}:${(state.timerRemaining % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.secondaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Upgrade'),
          ),
        ),
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (HomeState previous, HomeState current) =>
              previous.volume != current.volume,
          builder: (BuildContext context, HomeState state) {
            return PopupMenuButton<double>(
              icon: const Icon(Icons.volume_up, color: Colors.white),
              tooltip: 'Volume',
              itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
                PopupMenuItem<double>(
                  enabled: false,
                  child: SizedBox(
                    width: 200,
                    child: Slider(
                      value: state.volume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      onChanged: (double value) {
                        BlocProvider.of<HomeCubit>(context).setVolume(value);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        // Settings menu
        IconButton(
          onPressed: () =>
              context.router.navigateNamed(RouteConstants.settings),
          icon: const Icon(Icons.settings, color: Colors.white),
        ),
        // Full screen toggle
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.fullscreen, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
