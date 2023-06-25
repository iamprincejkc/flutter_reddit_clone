import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/community/screens/add_mods_screen.dart';
import 'package:reddit_clone/features/auth/community/screens/community_screen.dart';
import 'package:reddit_clone/features/auth/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/auth/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/auth/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/auth/home/screens/home_screen.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/posts/screens/add_post_screen.dart';
import 'package:reddit_clone/features/posts/screens/add_post_type_screen.dart';
import 'package:reddit_clone/features/posts/screens/comment_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: Uri.decodeComponent(route.pathParameters['name']!),
        ),
      ),
  '/mod-tools/:name': (route) => MaterialPage(
        child: ModToolsScreen(
          name: Uri.decodeComponent(route.pathParameters['name']!),
        ),
      ),
  '/edit-community/:name': (route) => MaterialPage(
        child: EditCommunityScreen(
          name: Uri.decodeComponent(route.pathParameters['name']!),
        ),
      ),
  '/add-mods/:name': (route) => MaterialPage(
        child: AddModsScreen(
          name: Uri.decodeComponent(route.pathParameters['name']!),
        ),
      ),
  '/u/:uid': (routeData) => MaterialPage(
        child: UserProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/edit-profile/:uid': (route) => MaterialPage(
        child: EditProfileScreen(
          uid: Uri.decodeComponent(route.pathParameters['uid']!),
        ),
      ),
  '/add-post/:type': (route) => MaterialPage(
        child: AddPostTypeScreen(
          type: Uri.decodeComponent(route.pathParameters['type']!),
        ),
      ),
  '/post/:postId/comments': (route) => MaterialPage(
        child: CommentScreen(
          postId: Uri.decodeComponent(route.pathParameters['postId']!),
        ),
      ),
  '/add-post': (route) => const MaterialPage(
        child: AddPostScreen(),
      ),
});
