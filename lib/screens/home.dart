import 'package:flutter/material.dart';
import 'package:yellow_movies/movies/boxes.dart';
import 'package:yellow_movies/movies/model/movie_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:yellow_movies/movies/screens/movieEditDialog.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Purple Movies'),
          centerTitle: true,
          backgroundColor: Colors.purple[400],
        ),
        body: ValueListenableBuilder<Box<Movie>>(
          valueListenable: Boxes.getMovie().listenable(),
          builder: (context, box, _) {
            final movies = box.values.toList().cast<Movie>();

            return buildContent(movies);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => movieEditDialog(
              onClickedDone: addMovie,
            ),
          ),
        ),
    );


  }

  Widget buildContent(List<Movie> movies) {
    if(movies.isEmpty){
      return Center(
        child: Text(
          'No Movies Added !',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];

                return buildMovie(context, movie);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildMovie(BuildContext context, Movie movie) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          movie.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(movie.director),
        children: [
          buildButtons(context, movie),
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
                onClickedDone: (name, director) =>
                    editMovie(movie, name, director),
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

  void editMovie(Movie movie, String name,String director) {
    movie.name = name;
    movie.director = director;

    movie.save();
  }

  deleteMovie(movie) {
    movie.delete();
  }

  Future addMovie(String name, String director) async {
    final movie = Movie()
      ..name = name
      ..director = director;

    final box = Boxes.getMovie();
    box.add(movie);
  }

}
