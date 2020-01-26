import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/src/models/i_post.dart';
import 'package:redux_example/src/redux/posts/posts_actions.dart';
import 'package:redux_example/src/redux/store.dart';

void main() async {
  await Redux.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoreProvider<AppState>(
        store: Redux.store,
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _onFetchPostsPressed() {
    Redux.store.dispatch(fetchPostsAction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Fetch Posts"),
            onPressed: _onFetchPostsPressed,
          ),
          StoreConnector<AppState, bool>(
            distinct: true,
            converter: (store) => store.state.postsState.isLoading,
            builder: (context, isLoading) {
              if (isLoading) {
                return CircularProgressIndicator();
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          StoreConnector<AppState, bool>(
            distinct: true,
            converter: (store) => store.state.postsState.isError,
            builder: (context, isError) {
              if (isError) {
                return Text("Failed to get posts");
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          Expanded(
            child: StoreConnector<AppState, List<IPost>>(
              distinct: true,
              converter: (store) => store.state.postsState.posts,
              builder: (context, posts) {
                return ListView(
                  children: _buildPosts(posts),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPosts(List<IPost> posts) {
    return posts
        .map(
          (post) => ListTile(
            title: Text(post.title),
            subtitle: Text(post.body),
            key: Key(post.id.toString()),
          ),
        )
        .toList();
  }
}
