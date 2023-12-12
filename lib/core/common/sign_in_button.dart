import 'package:ether_app/core/constants/constants.dart';
import 'package:ether_app/features/auth/controller/auth_controller.dart';
import 'package:ether_app/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
      child: ElevatedButton.icon(
        onPressed: () {
          signInWithGoogle(ref, context);
        }, 
        icon: Image.asset(Constants.googleLogoPath, width: 45,), 
        label: const Text("Sign in with Google", style: TextStyle(fontSize: 18),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50)
        ),
      ),
    );
  }
}