import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_provider.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Technology'),
            onTap: () => newsProvider.fetchNewsByCategory('technology'),
          ),
          ListTile(
            title: Text('Sports'),
            onTap: () => newsProvider.fetchNewsByCategory('sports'),
          ),
          ListTile(
            title: Text('Health'),
            onTap: () => newsProvider.fetchNewsByCategory('health'),
          ),
        ],
      ),
    );
  }
}
