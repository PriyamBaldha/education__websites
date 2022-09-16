import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebsitePage extends StatefulWidget {
  const WebsitePage({Key? key}) : super(key: key);

  @override
  State<WebsitePage> createState() => _WebsitePageState();
}

class _WebsitePageState extends State<WebsitePage> {
  double progress = 0;
  String url = "";
  final urlController = TextEditingController();

  final GlobalKey inAppWebViewKey = GlobalKey();

  late PullToRefreshController pullToRefreshController;

  InAppWebViewController? inAppWebViewController;

  final TextEditingController searchController = TextEditingController();

  String searchedText = "";

  List<String> allBookmarks = [];

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(color: Colors.blue),
        onRefresh: () async {
          if (Platform.isAndroid) {
            inAppWebViewController!.reload();
          }
          if (Platform.isIOS) {
            inAppWebViewController!.loadUrl(
                urlRequest:
                    URLRequest(url: await inAppWebViewController!.getUrl()));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${res['name']},",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_add_outlined),
            onPressed: () async {
              Uri? uri = await inAppWebViewController!.getUrl();

              allBookmarks.add(uri.toString());

              allBookmarks.toSet().toList();
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmarks),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Center(
                          child: Text("All Bookmarks"),
                        ),
                        content: SizedBox(
                          height: 280,
                          width: 300,
                          child: ListView.separated(
                            itemCount: allBookmarks.length,
                            itemBuilder: (context, i) => ListTile(
                              onTap: () async {
                                Navigator.of(context).pop();

                                await inAppWebViewController!.loadUrl(
                                  urlRequest: URLRequest(
                                    url: Uri.parse(
                                      allBookmarks[i],
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                allBookmarks[i],
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                            separatorBuilder: (context, i) => const Divider(
                              indent: 20,
                              endIndent: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ));
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          progress < 1
              ? LinearProgressIndicator(
                  value: progress,
                  color: Colors.deepOrange,
                )
              : Container(),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: TextField(
                controller: searchController,
                onSubmitted: (val) async {
                  searchedText = val;
                  Uri uri = Uri.parse(searchedText);

                  if (uri.scheme.isEmpty) {
                    uri = Uri.parse(
                        "https://www.google.com/search?q=" + searchedText);
                  }

                  await inAppWebViewController!
                      .loadUrl(urlRequest: URLRequest(url: uri));
                },
                decoration: const InputDecoration(
                  hintText: "search your website...",
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: InAppWebView(
              initialOptions: options,
              key: inAppWebViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse("${res['website']}"),
              ),
              onWebViewCreated: (controller) {
                inAppWebViewController = controller;
              },
              onProgressChanged: (controller, progress) async {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  searchController.text = this.url;
                });
              },
              onLoadStop: (controller, url) async {
                await pullToRefreshController.endRefreshing();

                searchController.text = url.toString();

                setState(
                  () {
                    searchController.text = url.toString();
                  },
                );
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await inAppWebViewController!.loadUrl(
                    urlRequest: URLRequest(
                      url: Uri.parse("${res['website']}"),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (await inAppWebViewController!.canGoBack()) {
                    await inAppWebViewController!.goBack();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await inAppWebViewController!.reload();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (await inAppWebViewController!.canGoForward()) {
                    await inAppWebViewController!.goForward();
                  }
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
