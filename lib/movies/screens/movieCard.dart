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
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.purple.withOpacity(0.8),
                  offset: Offset(3, 2),
                  blurRadius: 30)
            ]),
        child: Column(
          children: [
            SizedBox(height: 10),
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
                  SizedBox(height: 50),
                  Container(

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.file(
                          File(movie.posterPath),
                          fit: BoxFit.cover,
                          height: 420,
                          width: 320,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: RichText(text: TextSpan(children: [
                          TextSpan(text: '${movie.name} \n', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                          TextSpan(text: '${movie.director} \n', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

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
                    label: Text('Edit',style: TextStyle(color: Colors.purple[300])),
                    icon: Icon(Icons.edit,color: Colors.purple[300],),
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
                    label: Text('Delete',style: TextStyle(color: Colors.purple[300])),
                    icon: Icon(Icons.delete,color: Colors.purple[300],),
                    onPressed: () => deleteMovie(movie),
                  ),
                )
              ],
            )
          ],
        ),
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
