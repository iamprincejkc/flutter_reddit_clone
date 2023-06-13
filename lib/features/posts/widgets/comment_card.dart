import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment_mode.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.profilePic),
                radius: 18,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'u/${comment.username}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(comment.text),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.reply),
              ),
              const Text('Reply'),
            ],
          )
        ],
      ),
    );
  }
}
