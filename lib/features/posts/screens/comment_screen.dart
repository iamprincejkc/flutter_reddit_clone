import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/features/posts/widgets/comment_card.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/post_mode.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), post: post);
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(
              children: [
                PostCard(
                  post: data,
                ),
                const SizedBox(height: 10),
                TextField(
                  onSubmitted: ((value) => addComment(data)),
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Comment',
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
                ref.watch(getPostCommentsProvider(widget.postId)).when(
                    data: (data) {
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: ((context, index) {
                            final comment = data[index];
                            return CommentCard(comment: comment);
                          }),
                          itemCount: data.length,
                        ),
                      );
                    },
                    error: ((error, stackTrace) {
                      print(error.toString());
                      return ErrorText(error: error.toString());
                    }),
                    loading: (() => const Loader()))
              ],
            );
          },
          error: ((error, stackTrace) => ErrorText(error: error.toString())),
          loading: () => const Loader()),
    );
  }
}
