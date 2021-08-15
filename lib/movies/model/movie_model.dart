import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String director;

  // @HiveField(2)
  // late Uint8List image;


}
