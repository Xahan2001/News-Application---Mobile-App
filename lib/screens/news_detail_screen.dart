import 'package:flutter/material.dart';
import '../models/news_provider.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.urlToImage.isNotEmpty
                ? Image.network(article.urlToImage)
                : Container(
              height: 200,
              color: Colors.grey,
              child: Center(
                child: Text(
                  'No Image Available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              article.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
