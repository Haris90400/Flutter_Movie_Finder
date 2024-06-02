import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_finder/models/config.dart';

class HTTPService {
  final Dio _dio = Dio();
  final GetIt _getIt = GetIt.instance;

  String? _baseURl;
  String? _apiKey;

  HTTPService() {
    AppConfig _cofig = _getIt.get<AppConfig>();
    _baseURl = _cofig.BASE_API_URL;
    _apiKey = _cofig.API_KEY;
  }

  Future<Response?> get(String _path, Map<String, dynamic> query) async {
    try {
      String url = '$_baseURl$_path';

      Map<String, dynamic> _query = {
        'api-key': _apiKey,
        'language': 'en-US',
      };
      if (query != null) {
        _query.addAll(query);
      }
      return await _dio.get(
        _path,
        queryParameters: _query,
      );
    } on DioError catch (e) {
      print(e.error);
    }
  }
}
