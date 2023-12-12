import 'package:ether_app/core/common/error_text.dart';
import 'package:ether_app/core/common/loader.dart';
import 'package:ether_app/features/auth/controller/auth_controller.dart';
import 'package:ether_app/features/community/controller/community_controller.dart';
import 'package:ether_app/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (community) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(community.banner, fit: BoxFit.cover,)
                    )
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                          radius: 35,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("r/${community.name}", style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                          community.mods.contains(user!.uid) 
                            ? OutlinedButton(
                                onPressed: () => navigateToModTools(context),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30)
                                ),
                                child: const Text('Mod Tools')
                              )
                            : OutlinedButton(
                                onPressed: () => joinCommunity(ref, community, context),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30)
                                ),
                                child: Text(community.members.contains(user.uid) ? 'Joined' : 'Join')
                              )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.people),
                          const SizedBox(width: 5,),
                          Text('${community.members.length}')
                        ],
                      )
                    ]
                  )
                ),
              )
            ];
          }, 
          body: const Text("displaying posts")
        ), 
        error: (error, stackTrace) => ErrorText(error: error.toString()), 
        loading: () => const Loader()
      ),
    );
  }
}
