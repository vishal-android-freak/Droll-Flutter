import 'package:droll/Dashboard.dart';
import 'package:droll/ViewAllComics.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  final link = HttpLink(
    uri: 'https://droll-api.herokuapp.com/graphql',
  );

  final graphqlClient = GraphQLClient(cache: InMemoryCache(), link: link);

  ValueNotifier<GraphQLClient> client =
  ValueNotifier(graphqlClient);
  runApp(MainApp(
    client: client,
  ));
}

class MainApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  MainApp({@required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => Dashboard(),
            '/viewAll': (context) => ViewAllComics()
          }),
    );
  }
}
