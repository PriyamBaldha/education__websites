import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> Website = [
    {
      'id': 1,
      'name': 'wikipedia',
      'website': "https://www.wikipedia.com",
    },
    {
      'id': 2,
      'name': 'w3schools',
      'website': "https://www.w3schools.com",
    },
    {
      'id': 3,
      'name': 'javatpoint',
      'website': "https://www.javatpoint.com",
    },
    {
      'id': 4,
      'name': 'tutorialspoint',
      'website': "https://www.tutorialspoint.com"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Browser"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),
          ...Website.map((e) => Card(
                // color: Colors.greenAccent,
                elevation: 5,
                shape: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.grey,
                  width: 4,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  style: ListTileStyle.list,
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('WebsitePage', arguments: e);
                  },
                  subtitle: Text(
                    "${e['website']}",
                    style: const TextStyle(
                        //fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blueAccent),
                  ),
                  title: Text(
                    "${e['name']}",
                    style: const TextStyle(
                      //fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  leading: Text(
                    "${e['id']}",
                    style: const TextStyle(
                      //fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  trailing: const Icon(Icons.saved_search),
                ),
              )).toList()
        ],
      ),
    );
  }
}
