import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_finder/models/main_page_data.dart';
import 'package:movie_finder/models/movie.dart';
import 'package:movie_finder/models/search_category.dart';
import 'package:movie_finder/services/movie_service.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies();
  }

  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> _movies = [];

      if (!state.searchText.isEmpty) {
        print(
            "Else triggered"); // This line will be reached when searchText is not empty
        _movies = (await _movieService.getSearchedMovies(state.searchText,
                page: state.page)) ??
            [];
      } else {
        if (state.category == SearchCategory.popular) {
          _movies = (await _movieService.getPopularMovies(page: state.page))!;
        } else if (state.category == SearchCategory.upcoming) {
          _movies = (await _movieService.getUpcomingMovies(page: state.page))!;
        } else if (state.category == SearchCategory.none) {
          _movies = [];
        }
      }

      print(_movies);
      state = state.copyWith(
        movies: [...state.movies, ..._movies],
        page: state.page + 1,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void updateCategory(String category) {
    try {
      state = state.copyWith(
        movies: [],
        page: 1,
        category: category,
        searchText: '',
      );
      getMovies();
    } catch (e) {
      print(e.toString());
    }
  }

  void updateTextSearch(String searchQuery) {
    try {
      state = state.copyWith(
        movies: [],
        page: 1,
        category: SearchCategory.none,
        searchText: searchQuery,
      );

      getMovies();
    } catch (e) {
      print(e.toString());
    }
  }
}
