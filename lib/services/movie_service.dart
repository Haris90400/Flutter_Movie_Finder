import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_finder/models/movie.dart';
import 'package:movie_finder/services/http_service.dart';

class MovieService {
  final GetIt _getIt = GetIt.instance;

  HTTPService? _httpService;

  MovieService() {
    _httpService = _getIt.get<HTTPService>();
  }

  Future<List<Movie>?> getPopularMovies({required int page}) async {
    Response? _response = await _httpService!.get(
      '/movie/popular',
      {
        'page': page.toInt(),
      },
    );

    if (_response!.statusCode == 200) {
      Map _data = _response.data;

      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJSON(_movieData);
      }).toList();

      return _movies;
    } else {
      throw Exception('Could not load popular movies');
    }
  }
}
