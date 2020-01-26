import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:meta/meta.dart';
import 'package:redux_example/src/models/i_post.dart';
import 'package:redux_example/src/redux/posts/posts_state.dart';
import 'package:redux_example/src/redux/store.dart';
import 'package:http/http.dart' as http;

@immutable
class SetPostsStateAction {
  final PostsState postsState;

  SetPostsStateAction(this.postsState);
}

Future<void> fetchPostsAction(Store<AppState> store) async {
  store.dispatch(SetPostsStateAction(PostsState(isLoading: true)));

  try {
    final response = await http.get('https://jsonplaceholder.typicode.com/posts');
    assert(response.statusCode == 200);
    final jsonData = json.decode(response.body);
    store.dispatch(
      SetPostsStateAction(
        PostsState(
          isLoading: false,
          posts: IPost.listFromJson(jsonData),
        ),
      ),
    );
  } catch (error) {
    store.dispatch(SetPostsStateAction(PostsState(isLoading: false)));
  }
}
