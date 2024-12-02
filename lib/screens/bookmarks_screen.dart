import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_provider.dart';

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: newsProvider.bookmarkedArticles.isEmpty
          ? Center(child: Text('No bookmarks yet!'))
          : ListView.builder(
        itemCount: newsProvider.bookmarkedArticles.length,
        itemBuilder: (context, index) {
          final article = newsProvider.bookmarkedArticles[index];
          return ListTile(
            leading: article.urlToImage != ''
                ? Image.network(article.urlToImage, width: 50, height: 50, fit: BoxFit.cover)
                : SizedBox(width: 50, height: 50),
            title: Text(article.title),
            subtitle: Text(article.description),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => newsProvider.removeBookmark(article),
            ),
          );
        },
      ),
    );
  }
}
