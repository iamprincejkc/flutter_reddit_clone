import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';

import '../../../core/failure.dart';
import '../../../core/provider/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/comment_mode.dart';
import '../../../models/community_model.dart';
import '../../../models/post_mode.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(fireStoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).set(post.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities
                .map(
                  (e) => e.name,
                )
                .toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove([userId])
        },
      );
    }

    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove([userId])
        },
      );
    } else {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayUnion([userId])
        },
      );
    }
  }

  void downvote(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove([userId])
        },
      );
    }

    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove([userId])
        },
      );
    } else {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayUnion([userId])
        },
      );
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (event) => Post.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_posts
          .doc(comment.postId)
          .update({'commentCount': FieldValue.increment(1)}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Comment.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}
