import 'package:ether_app/features/auth/controller/auth_controller.dart';
import 'package:ether_app/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void naviagteToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 60,
            ),
            const SizedBox(height: 10,),
            Text('u/${user.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
            const SizedBox(height: 10,),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () => naviagteToUserProfile(context, user.uid)
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(Icons.logout, color: Pallete.redColor,),
              onTap: () => logout(ref)
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark, 
              onChanged: (val) => toggleTheme(ref), 
              activeColor: Pallete.greenColor
            )
          ],
        )
      ),
    );
  }
}