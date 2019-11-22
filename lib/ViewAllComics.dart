import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAllComics extends StatelessWidget {
  final allComics = r'''
  query GetAllComics($name: name) {
    feed(name: $name) {
      id
      imageURL
      published
      description
      title
      link
    }
  }
  ''';

  @override
  Widget build(BuildContext context) {
    final comicNameData =
        ModalRoute.of(context).settings.arguments as Map<String, String>;

    return Scaffold(
        backgroundColor: Color(0xfffafafa),
        appBar: AppBar(
          title: Text("${comicNameData["comicName"]}"),
        ),
        body: Query(
          options: QueryOptions(
              document: allComics,
              variables: {"name": comicNameData["queryName"]}),
          builder: (QueryResult result, {refetch, fetchMore}) {
            if (result.loading) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }

            if (result.hasErrors) {
              //TODO: Handle errors
              print(result.errors);
              return Container();
            }

            var comicData = result.data["feed"] as List<dynamic>;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: comicData.length,
              itemBuilder: (context, index) {
                return _comicDetailCard(comicData[index]);
              },
            );
          },
        ));
  }

  Widget _comicDetailCard(Map<String, dynamic> comicData) {
    return GestureDetector(
      onTap: () async {
        var link = comicData['link'];
        if (await canLaunch(link)) {
          launch(link);
        } else {
          //TODO: Handle this gracefully
        }
      },
      child: Card(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Image.network(
                  comicData["imageURL"],
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      comicData['title'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    if (comicData['description'] != '')
                      SizedBox(
                        height: 8,
                      ),
                    if (comicData['description'] != '')
                      Text(
                        comicData['description'],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    SizedBox(
                      height: 8,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
