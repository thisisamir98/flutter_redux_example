import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_example/src/redux/posts/posts_actions.dart';
import 'package:redux_example/src/redux/posts/posts_reducer.dart';
import 'package:redux_example/src/redux/posts/posts_state.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetPostsStateAction) {
    final nextPostsState = postsReducer(state.postsState, action);

    return state.copyWith(postsState: nextPostsState);
  }

  return state;
}

@immutable
class AppState {
  final PostsState postsState;

  AppState({
    @required this.postsState,
  });

  AppState copyWith({
    PostsState postsState,
  }) {
    return AppState(
      postsState: postsState ?? this.postsState,
    );
  }
}

class Redux {
  static Store<AppState> _store;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    final postsStateInitial = PostsState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(postsState: postsStateInitial),
    );
  }
}
