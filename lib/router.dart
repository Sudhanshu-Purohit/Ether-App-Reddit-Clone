import 'package:ether_app/features/auth/screens/login_screen.dart';
import 'package:ether_app/features/community/screens/add_mods_screen.dart';
import 'package:ether_app/features/community/screens/community_screen.dart';
import 'package:ether_app/features/community/screens/create_community_screen.dart';
import 'package:ether_app/features/community/screens/edit_community_screen.dart';
import 'package:ether_app/features/community/screens/mod_tools_screen.dart';
import 'package:ether_app/features/home/screens/home_screen.dart';
import 'package:ether_app/features/posts/screens/add_post_type_screen.dart';
import 'package:ether_app/features/user_profile/screens/edit_profile_screen.dart';
import 'package:ether_app/features/user_profile/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});


final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(child: CommunityScreen(
    name: route.pathParameters['name']!
  )),
  '/mod-tools/:name': (route) => MaterialPage(child: ModToolsScreen(
    name: route.pathParameters['name']!
  )),
  '/edit-community/:name': (route) => MaterialPage(child: EditCommunityScreen(
    name: route.pathParameters['name']!
  )),
  '/add-mods/:name': (route) => MaterialPage(child: AddModsScreen(
    name: route.pathParameters['name']!
  )),
  '/u/:uid': (route) => MaterialPage(child: UserProfileScreen(
    uid: route.pathParameters['uid']!
  )),
  '/edit-profile/:uid': (route) => MaterialPage(child: EditProfileScreen(
    uid: route.pathParameters['uid']!
  )),
  '/add-post/:type': (route) => MaterialPage(child: AddPostTypeScreen(
    type: route.pathParameters['type']!
  )),
});