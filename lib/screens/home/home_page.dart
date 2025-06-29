import 'package:ambientflow/services/di/service_locator.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/bookmark/bookmark_cubit.dart';
import '../../widgets/animated_background/animated_background_widget.dart';
import '../../widgets/animated_background/cubit/background_cubit.dart';
import '../../widgets/bookmark/save_bookmark_dialog.dart';
import '../../widgets/bookmark/vertical_bookmark_list.dart';
import '../../widgets/cookie_consent_banner.dart';
import '../../widgets/custom_app_bar.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/main_content_section.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeCubit homeCubit = HomeCubit(
    appState: getIt<AppState>(),
  );
  final BackgroundCubit backgroundCubit = BackgroundCubit();
  final BookmarkCubit bookmarkCubit = getIt<BookmarkCubit>();
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    // Initialize bookmark cubit
    bookmarkCubit.initialize();
  }

  @override
  void dispose() {
    homeCubit.close();
    backgroundCubit.close();
    bookmarkCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => homeCubit,
        ),
        BlocProvider<BackgroundCubit>(
          create: (BuildContext context) => backgroundCubit,
        ),
        BlocProvider<BookmarkCubit>.value(
          value: bookmarkCubit,
        ),
      ],
      child: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<HomeCubit, HomeState>(
            listener: (BuildContext context, HomeState state) {},
          ),
          BlocListener<BookmarkCubit, BookmarkState>(
            listener: (BuildContext context, BookmarkState bookmarkState) {
              // Sync home cubit when bookmarks are applied
              if (bookmarkState.status == BookmarkStatus.uiRefreshNeeded) {
                homeCubit.syncWithAppState();
              }
              // Show save dialog as modal
              if (bookmarkState.showSaveDialog && !_isDialogShowing) {
                _isDialogShowing = true;
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) =>
                      BlocProvider<BookmarkCubit>.value(
                    value: bookmarkCubit,
                    child: const SaveBookmarkDialog(),
                  ),
                ).then((_) {
                  _isDialogShowing = false;
                  // Hide the dialog state when dialog is closed
                  bookmarkCubit.hideSaveDialog();
                });
              }
            },
          ),
        ],
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Determine if we're on a mobile, tablet, or desktop
            final bool isDesktop = constraints.maxWidth > 1100;
            final bool isTablet =
                constraints.maxWidth > 650 && constraints.maxWidth <= 1100;
            final bool isMobile = constraints.maxWidth <= 650;

            return Scaffold(
              // Use a transparent background since we'll use our custom animated background
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: const CustomAppBar(),
              // Stack the background and content
              body: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: <Widget>[
                  // Animated background
                  const AnimatedBackgroundWidget(),
                  // Content
                  MainContentSection(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  ),

                  // Vertical bookmark list on the right side
                  const VerticalBookmarkList(),

                  // Cookie consent banner
                  const CookieConsentBanner(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
