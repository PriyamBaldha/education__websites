import 'package:educational_websites/wesitePage.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'HomePage',
      routes: {
        'HomePage': (context) => const HomePage(),
        'WebsitePage': (context) => const WebsitePage(),
      }));
}
