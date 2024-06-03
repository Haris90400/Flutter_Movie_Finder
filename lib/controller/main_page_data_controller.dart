import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_finder/models/main_page_data.dart';
import 'package:movie_finder/models/movie.dart';
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

      _movies = (await _movieService.getPopularMovies(page: state.page))!;
      print(_movies);
      state = state.copyWith(
        movies: [...state.movies, ..._movies],
        page: state.page + 1,
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
