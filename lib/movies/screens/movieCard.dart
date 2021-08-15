import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yellow_movies/movies/model/movie_model.dart';
import 'package:yellow_movies/movies/screens/movieEditDialog.dart';

import '../boxes.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            height: 420,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color:
                  Color.fromARGB(62, 168, 174, 201),
                  offset: Offset(0, 9),
                  blurRadius: 14,
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Image.file(
                    File(movie.posterPath),
                    fit: BoxFit.cover,
                    height: 420,
                    width: 320,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: RichText(text: TextSpan(children: [
                        TextSpan(text: '${movie.name} \n', style: TextStyle(fontSize: 22)),
                        TextSpan(text: '${movie.director} \n', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                      ]))
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  label: Text('Edit'),
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => movieEditDialog(
                        movie: movie,
                        onClickedDone: (name, director, posterPath) =>
                            editMovie(movie, name, director, posterPath),
                      ),

                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  label: Text('Delete'),
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteMovie(movie),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  buildButtons(BuildContext context, Movie movie) => Row(
    children: [
      Expanded(
        child: TextButton.icon(
          label: Text('Edit'),
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => movieEditDialog(
                movie: movie,
                onClickedDone: (name, director, posterPath) =>
                    editMovie(movie, name, director, posterPath),
              ),

            ),
          ),
        ),
      ),
      Expanded(
        child: TextButton.icon(
          label: Text('Delete'),
          icon: Icon(Icons.delete),
          onPressed: () => deleteMovie(movie),
        ),
      )
    ],
  );


  void editMovie(Movie movie, String name,String director, String posterPath) {
    movie.name = name;
    movie.director = director;
    movie.posterPath = posterPath;

    movie.save();
  }

  deleteMovie(movie) {
    movie.delete();
  }


}
