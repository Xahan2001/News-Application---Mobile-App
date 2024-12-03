import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_provider.dart';
import '../models/theme_provider.dart'; // Import theme provider
import 'news_detail_screen.dart';
import 'saved_news_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'A-Z';
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory(_selectedCategory);
  }

  // Sorting function based on title (A-Z, Z-A)
  void _sortArticles(List articles) {
    switch (_sortOption) {
      case 'A-Z':
        articles.sort((a, b) => a.title.compareTo(b.title)); // Alphabetical order
        break;
      case 'Z-A':
        articles.sort((a, b) => b.title.compareTo(a.title)); // Reverse alphabetical order
        break;
    }
  }

  // Select category and fetch news
  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category.toLowerCase(); // Lowercase for API compatibility
    });
    Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final filteredArticles = newsProvider.articles
        .where((article) =>
        article.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    _sortArticles(filteredArticles);

    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          // Sorting Menu in the top right corner
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _sortOption = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return ['A-Z', 'Z-A']
                  .map((String choice) => PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              ))
                  .toList();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'News App',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Saved News'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedNewsScreen(),
                  ),
                );
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category Selector
          Container(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _categoryButton('General'),
                  _categoryButton('Business'),
                  _categoryButton('Technology'),
                  _categoryButton('Sports'),
                  _categoryButton('Health'),
                  _categoryButton('Entertainment'),
                  _categoryButton('Science'),
                ],
              ),
            ),
          ),
          Expanded(
            child: newsProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : newsProvider.errorMessage != null
                ? Center(child: Text('Error: ${newsProvider.errorMessage}'))
                : ListView.builder(
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
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
                    icon: Icon(
                      newsProvider.bookmarkedArticles.contains(article)
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                    ),
                    onPressed: () =>
                        newsProvider.toggleBookmark(article),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Category button widget
  Widget _categoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () => _selectCategory(category),
        child: Text(category),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            _selectedCategory == category.toLowerCase()
                ? Colors.blue
                : Colors.white,
          ),
          foregroundColor: MaterialStateProperty.all(
            _selectedCategory == category.toLowerCase()
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
