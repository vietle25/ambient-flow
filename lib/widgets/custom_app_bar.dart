import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_strings.dart';
import '../constants/app_styles.dart';
import '../navigation/route_constants.dart';
import '../screens/home/cubit/home_cubit.dart';
import '../screens/home/cubit/home_state.dart';
import 'auth/login_button.dart';

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
              previous.volume != current.volume,
          builder: (BuildContext context, HomeState state) {
            return PopupMenuButton<double>(
              icon: const Icon(Icons.volume_up, color: Colors.white),
              tooltip: 'Volume',
              // Set offset to position the menu below the app bar
              offset: const Offset(0, 8),
              // Use a shape with rounded corners
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // Set elevation for better shadow
              elevation: 8,
              // Set position to ensure it appears below the app bar
              position: PopupMenuPosition.under,
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
        // Login button
        LoginButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
