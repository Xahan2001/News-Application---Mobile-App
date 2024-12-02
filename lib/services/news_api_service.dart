import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String apiKey = '63aca5737e0543d9ba6e1f5b122c9a04';
  final String baseUrl = 'https://newsapi.org/v2';

  Future<List<dynamic>> fetchNews({String query = '', String category = ''}) async {
    String url = '$baseUrl/top-headlines?apiKey=$apiKey&country=us';

    if (query.isNotEmpty) {
      url += '&q=$query';
    }

    if (category.isNotEmpty) {
      url += '&category=$category';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok' && data['articles'] != null) {
          return data['articles'];
        } else {
          throw Exception('Failed to fetch news: ${data['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in NewsApiService: $e');
      rethrow;
    }
  }
}
