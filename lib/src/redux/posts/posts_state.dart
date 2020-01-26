import 'package:meta/meta.dart';
import 'package:redux_example/src/models/i_post.dart';

@immutable
class PostsState {
  final bool isError;
  final bool isLoading;
  final List<IPost> posts;

  PostsState({
    this.isError,
    this.isLoading,
    this.posts,
  });

  factory PostsState.initial() => PostsState(
        isLoading: false,
        isError: false,
        posts: const [],
      );

  PostsState copyWith({
    @required bool isError,
    @required bool isLoading,
    @required List<IPost> posts,
  }) {
    return PostsState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
    );
  }
}
