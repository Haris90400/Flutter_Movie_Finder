import 'package:get_it/get_it.dart';
import 'package:movie_finder/services/http_service.dart';

class MovieService {
  final GetIt _getIt = GetIt.instance;

  HTTPService? _httpService;

  MovieService() {
    _httpService = _getIt.get<HTTPService>();
  }
}
