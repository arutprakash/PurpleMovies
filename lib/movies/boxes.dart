import 'package:hive/hive.dart';
import 'package:yellow_movies/movies/model/movie_model.dart';

class Boxes {
  static Box<Movie> getMovie() =>
      Hive.box<Movie>('movie');
}
