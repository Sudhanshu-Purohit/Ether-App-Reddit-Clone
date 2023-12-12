import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:ether_app/core/common/error_text.dart';
import 'package:ether_app/core/common/loader.dart';
import 'package:ether_app/core/constants/constants.dart';
import 'package:ether_app/core/utils.dart';
import 'package:ether_app/features/auth/controller/auth_controller.dart';
import 'package:ether_app/features/user_profile/controller/user_profile_controller.dart';
import 'package:ether_app/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
 
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if(res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if(res != null) {
      profileFile = File(res.files.first.path!);
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
      profileFile: profileFile, 
      bannerFile: bannerFile, 
      context: context, 
      name: nameController.text.trim()
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (user) => Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Edit Profile', style: TextStyle(fontSize: 20),),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: save, 
              child: const Text('Save')
            )
          ],
        ),
        body: isLoading ? const Loader() : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: currentTheme.textTheme.bodyLarge!.color!,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: bannerFile != null
                            ? Image.file(bannerFile!)
                            : user.banner.isEmpty || user.banner == Constants.bannerDefault 
                            ? const Icon(Icons.camera_alt_rounded, size: 40,)
                            : Image.network(user.banner),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: selectProfileImage,
                        child: profileFile != null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: FileImage(profileFile!),
                            )
                          : CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(user.profilePic,),
                          ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18)
                ),
              ),
            )
          ],
        ),
      ), 
      error: (error, stackTrace) => ErrorText(error: error.toString()), 
      loading: () => const Loader()
    );
  }
}