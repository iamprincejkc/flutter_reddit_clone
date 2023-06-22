import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/community/controller/community_controller.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../models/post_mode.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final curentTheme = ref.watch(themeNotifierProvider);
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: curentTheme.drawerTheme.backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                            .copyWith(right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => navigateToCommunity(context),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.communityProfilePic),
                                    radius: 16,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'r/${post.communityName}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () => navigateToUser(context),
                                        child: Text(
                                          'u/${post.username}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (post.uid == user.uid)
                              IconButton(
                                onPressed: () => deletePost(ref, context),
                                icon: Icon(
                                  Icons.delete,
                                  color: Pallete.redColor,
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            post.title,
                            style: const TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (isTypeImage)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            child: Image.network(
                              post.link!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (isTypeLink)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: AnyLinkPreview(
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                              link: post.link!,
                            ),
                          ),
                        if (isTypeText)
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => upvotePost(ref),
                                  icon: Icon(
                                    Constants.up,
                                    size: 30,
                                    color: post.upvotes.contains(user.uid)
                                        ? Pallete.redColor
                                        : null,
                                  ),
                                ),
                                Text(
                                  '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                  style: const TextStyle(fontSize: 17),
                                ),
                                IconButton(
                                  onPressed: () => downvotePost(ref),
                                  icon: Icon(
                                    Constants.down,
                                    size: 30,
                                    color: post.downvotes.contains(user.uid)
                                        ? Pallete.blueColor
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => navigateToComments(context),
                                  icon: const Icon(Icons.comment),
                                ),
                                Text(
                                  '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                            ref
                                .watch(getCommunityByNameProvider(
                                    post.communityName))
                                .when(
                                    data: (data) {
                                      if (data.mods.contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () =>
                                              deletePost(ref, context),
                                          icon: const Icon(
                                              Icons.admin_panel_settings),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    error: ((error, stackTrace) =>
                                        ErrorText(error: error.toString())),
                                    loading: (() => const Loader()))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
