import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:ether_app/core/common/error_text.dart';
import 'package:ether_app/core/common/loader.dart';
import 'package:ether_app/core/constants/constants.dart';
import 'package:ether_app/core/utils.dart';
import 'package:ether_app/features/community/controller/community_controller.dart';
import 'package:ether_app/models/community_model.dart';
import 'package:ether_app/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
 
  File? bannerFile;
  File? profileFile;

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

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
      profileFile: profileFile,
      bannerFile: bannerFile, 
      context: context, 
      community: community
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
      data: (community) => Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Edit Community', style: TextStyle(fontSize: 20),),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () => save(community), 
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
                            : community.banner.isEmpty || community.banner == Constants.bannerDefault 
                            ? const Icon(Icons.camera_alt_rounded, size: 40,)
                            : Image.network(community.banner),
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
                            backgroundImage: NetworkImage(community.avatar,),
                          ),
                      ),
                    )
                  ],
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