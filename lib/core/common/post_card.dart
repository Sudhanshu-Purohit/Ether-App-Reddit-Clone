import 'package:any_link_preview/any_link_preview.dart';
import 'package:ether_app/core/constants/constants.dart';
import 'package:ether_app/features/auth/controller/auth_controller.dart';
import 'package:ether_app/features/posts/controller/post_controller.dart';
import 'package:ether_app/models/post_model.dart';
import 'package:ether_app/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;

    final currentTheme = ref.watch(themeNotifierProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(post.communityProfilePic),
                                    radius: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('r/${post.communityName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                        Text('u/${post.username}', style: const TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if(post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context), 
                                  icon: Icon(Icons.delete, color: Pallete.redColor,)
                                )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(post.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                          ),
                          if(isTypeImage)
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.35,
                            width: double.infinity,
                            child: Image.network(post.link!),
                          ),
                          if(isTypeLink)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AnyLinkPreview(
                              displayDirection: UIDirection.uiDirectionHorizontal,
                              link: post.link!
                            ),
                          ),
                          if(isTypeText)
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(post.description!, style: const TextStyle(color: Colors.grey),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => upvotePost(ref), 
                                    icon: Icon(Constants.up, size: 25, color: post.upvotes.contains(user.uid) ? Pallete.redColor : null,)
                                  ),
                                  Text('${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}'),
                                  IconButton(
                                    onPressed: () => downvotePost(ref), 
                                    icon: Icon(Constants.down, size: 25, color: post.downvotes.contains(user.uid) ? Pallete.blueColor : null,)
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: const Icon(Icons.comment)
                                  ),
                                  Text('${post.commentCount == 0 ? 'Comment' : post.commentCount}'),
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.admin_panel_settings)
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ],
    );
  }
}