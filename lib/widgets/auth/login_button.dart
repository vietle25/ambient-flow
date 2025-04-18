import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';
import '../../models/user_model.dart';

/// A button that allows users to log in.
class LoginButton extends StatelessWidget {
  /// Creates a new [LoginButton] instance.
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState state) {
        if (state.isLoading) {
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          );
        }

        if (state.isAuthenticated) {
          return _buildUserAvatar(context, state.user);
        }

        return _buildLoginButton(context);
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.person_outline, color: Colors.white),
        tooltip: 'Login',
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
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'google',
            child: Row(
              children: <Widget>[
                Icon(Icons.g_mobiledata, color: Colors.red, size: 30),
                SizedBox(width: 8),
                Text('Sign in with Google'),
              ],
            ),
          ),
          // Add more login methods here in the future
        ],
        onSelected: (String value) {
          if (value == 'google') {
            context.read<AuthCubit>().signInWithGoogle();
          }
        },
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context, UserModel? user) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: PopupMenuButton<String>(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: user?.photoUrl != null
              ? CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(user!.photoUrl!),
                )
              : const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryBackground,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (user?.email != null)
                  Text(
                    user!.email!,
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: <Widget>[
                Icon(Icons.person_outline),
                SizedBox(width: 8),
                Text('Profile'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: <Widget>[
                Icon(Icons.logout),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          ),
        ],
        onSelected: (String value) {
          if (value == 'logout') {
            context.read<AuthCubit>().signOut();
          } else if (value == 'profile') {
            // Navigate to profile page
            // To be implemented in the future
          }
        },
      ),
    );
  }
}
