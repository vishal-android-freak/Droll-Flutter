import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Dashboard extends StatelessWidget {
  final comicFeed = r'''
  query GetComicsFeed($name: name) {
    feed(name: $name, limit: 10, offset: 0) {
      id
      imageURL
      published
      title
    }
  }
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffafafa),
        appBar: AppBar(
          title: const Text("Droll"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _comicsTitle("xkcd Comics", context),
                _comicsList("xkcd"),
                SizedBox(
                  height: 16,
                ),
                _comicsTitle("PHD Comics", context),
                _comicsList("phdcomic"),
              ],
            )));
  }

  Widget _comicCard(Map<String, dynamic> comicData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 180,
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Image.network(
                comicData["imageURL"],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      comicData['title'],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Published: ",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        ),
                        Text(
                          comicData['published'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _comicsTitle(String comicName, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              comicName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            _viewAllButton(context)
          ],
        ));
  }

  Widget _comicsList(String comicName) {
    return Query(
      options:
          QueryOptions(document: comicFeed, variables: {"name": comicName}),
      builder: (QueryResult result, {refetch, fetchMore}) {
        if (result.loading) {
          return const Center(
              child: const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ));
        }
        if (result.hasErrors) {
          //TODO: HANDLE ERROR
          print(result.errors);
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
  }

  Widget _viewAllButton(BuildContext context) {
    return FlatButton(
      child: const Text("View All"),
      onPressed: () {
        Navigator.of(context).pushNamed('/viewAll');
      },
    );
  }
}
