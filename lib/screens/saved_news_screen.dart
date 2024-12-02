import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_provider.dart';
import 'news_detail_screen.dart';

class SavedNewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved News'),
      ),
      body: newsProvider.bookmarkedArticles.isEmpty
          ? Center(
        child: Text('No saved news available.'),
      )
          : ListView.builder(
        itemCount: newsProvider.bookmarkedArticles.length,
        itemBuilder: (context, index) {
          final article = newsProvider.bookmarkedArticles[index];
          return ListTile(
            leading: article.urlToImage.isNotEmpty
                ? Image.network(
              article.urlToImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : SizedBox(width: 50, height: 50),
            title: Text(article.title),
            subtitle: Text(article.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewsDetailScreen(article: article),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                newsProvider.toggleBookmark(article);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('News removed from saved list')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
