// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get_it/get_it.dart';
import 'package:movie_finder/models/config.dart';

class Movie {
  final String name;
  final String language;
  final bool isAdult;
  final String description;
  final String? posterPath; // Made posterPath nullable
  final String? backdropPath; // Made backdropPath nullable
  final double rating;
  final String releaseDate;

  Movie({
    required this.name,
    required this.language,
    required this.isAdult,
    required this.description,
    this.posterPath, // Made posterPath nullable
    this.backdropPath, // Made backdropPath nullable
    required this.rating,
    required this.releaseDate,
  });

  factory Movie.fromJSON(Map<String, dynamic> _json) {
    return Movie(
      name: _json['title'],
      language: _json['original_language'],
      isAdult: _json['adult'],
      description: _json['overview'],
      posterPath: _json['poster_path'], // Assign nullable value
      backdropPath: _json['backdrop_path'], // Assign nullable value
      rating: _json['vote_average'],
      releaseDate: _json['release_date'],
    );
  }

  String posterUrl() {
    final AppConfig _appConfig = GetIt.instance.get<AppConfig>();
    return posterPath != null
        ? '${_appConfig.BASE_IMAGE_API_URL}$posterPath'
        : ''; // Return an empty string if posterPath is null
  }
}
