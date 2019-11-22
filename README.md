# Flutter App for Droll 
![GitHub](https://img.shields.io/github/license/vishal-android-freak/Droll-flutter)
![GitHub issues](https://img.shields.io/github/issues/vishal-android-freak/Droll-flutter)

Flutter Implementation of Droll GraphQL APIs - https://github.com/prabhuomkar/droll-api

[Demo](https://drive.google.com/file/d/130NvNqnJsa4v1BaKa5pVHG8E3elq-sDZ/view?usp=sharing)

![image](https://user-images.githubusercontent.com/5111523/69413282-8771d200-0d36-11ea-9a10-d27aa16fca9a.png)
![image](https://user-images.githubusercontent.com/5111523/69413210-64472280-0d36-11ea-9bd8-994f6720f539.png)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


- Clone this repository
- Check if you have connected your device with `USB Debugging` on from Developer tools
- In the terminal, type

```$ flutter devices```

If none of the devices are shown, follow [these](https://flutter.dev/docs/get-started/install) instructions.

- Run the app

```$ flutter run```

## Flutter Topics Explored

- [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html)
- [ListView & ListView Builder](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html)
- [Column](https://api.flutter.dev/flutter/widgets/Column-class.html)
- [Row](https://api.flutter.dev/flutter/widgets/Row-class.html)
- [FlatButton](https://api.flutter.dev/flutter/material/FlatButton-class.html)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [graphql_flutter](https://pub.dev/packages/graphql_flutter)
- Widget Composition

## GraphQL Guide

- Those who are new to Graphql, check out - [howtographql](https://www.howtographql.com/)

[graphql_flutter](https://pub.dev/packages/graphql_flutter) provides direct widgets for `Query`, `Mutation` and `Subscription`. The subscription is pretty straightforward and if you are familiar with [Apollo GraphQL](https://www.apollographql.com/docs/react/api/apollo-client/), the syntax is similar.

- Setting up GraphQL Client
```dart
final link = HttpLink(
    uri: 'https://droll-api.herokuapp.com/graphql',
  );

final graphqlClient = GraphQLClient(cache: InMemoryCache(), link: link);

ValueNotifier<GraphQLClient> client = ValueNotifier(graphqlClient);
runApp(
  MainApp(
    client: client,
  )
);
```
- Inject client in the app widget tree using `GraphQLProvider`
```dart
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
            '/viewAll': (context) => ViewAllComics(),
          }),
    );
  }
```
- Now use the `Query` widget to query the DB. Major advantage of using GraphQL is that you can ask the server to send only those values required to be shown in the UI.

A Query widget takes the following parameters:
- `document` - The query string
- `variables` - The variables to be passed in the query.

It returns an `itemBuilder` which can be used to access the data obtained from the query. Let's take the example of retriving 10 books of PHD comics:
```dart

// A raw dart string with the GraphQL query for getting the comics
final comicFeed = r'''
  query GetComicsFeed($name: name) {
    feed(name: $name, limit: 10, offset: 0) {
      id
      imageURL
      published
      title
      link
    }
  }
  ''';
  
  // You can call this somewhere inside the build() method of the component
    return Query(
      options:
          QueryOptions(document: comicFeed, variables: {"name": "phdcomic"}),
      builder: (QueryResult result, {refetch, fetchMore}) {
        if (result.loading) {
          return const Center(
              child: const Padding(
            padding: const EdgeInsets.all(16),
            child: const CircularProgressIndicator(),
          ));
        }
        if (result.hasErrors) {
          //TODO: HANDLE ERROR
          print(result.errors);
          return Container();
        }
        var data = result.data["feed"] as List<dynamic>;
        return SizedBox(
            height: 240,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return _comicCard(data[index]);
                }));
      },
    );
```
- The `itemBuilder` returns a `QueryResult` object which helps you to keep track of the `loading` state when the data is being fetched, `errors` and the data obtained from the server as `result.data`.

## Contributing

We are open to pull-requests and issues from the community. Please make sure you raise issues with examples which can help us reproduce them. Here are few articles to help you get started:

- [Create pull requests on github](https://opensource.com/article/19/7/create-pull-request-github)
- [Pull Requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request)
- [Create issues](https://help.github.com/en/github/managing-your-work-on-github/creating-an-issue)
