import 'package:movie_finder/models/movie.dart';
import 'package:movie_finder/models/search_category.dart';

class MainPageData {
  final List<Movie> movies;
  final int page;
  final String category;
  final String searchText;

  MainPageData({
    required this.movies,
    required this.page,
    required this.category,
    required this.searchText,
  });

  MainPageData.initial()
      : movies = [],
        page = 1,
        category = SearchCategory.popular,
        searchText = '';

  MainPageData copyWith(
      {List<Movie>? movies, int? page, String? category, String? searchText}) {
    return MainPageData(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      category: category ?? this.category,
      searchText: searchText ?? this.searchText,
    );
  }
}
