import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellow_movies/auth/screens/boarding_page.dart';
import 'package:yellow_movies/auth/services/user_provider.dart';
import 'package:yellow_movies/movies/boxes.dart';
import 'package:yellow_movies/movies/model/movie_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:yellow_movies/movies/screens/movieCard.dart';
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
    UserProvider auth = Provider.of<UserProvider>(context);
    Hive.openBox<Movie>('movie');

    return  Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Purple Movies'),
          centerTitle: true,
          backgroundColor: Colors.purple[400],
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                if(await auth.logout()){
                  // Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BoardingPage()));
                }
              },
            )
          ],
        ),
        body: ValueListenableBuilder<Box<Movie>>(
          valueListenable: Boxes.getMovie().listenable(),
          builder: (context, box, _) {
            final movies = box.values.toList().cast<Movie>();

            return buildContent(movies);
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple[300],
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
    UserProvider auth = Provider.of<UserProvider>(context);
    if(movies.isEmpty){
      return Center(
        child: Text(
          'Add your fav Movies !!',
          style: TextStyle(fontSize: 24,color: Colors.purple[300]),
        ),
      );
    } else {
      return Column(
        children: [
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
    return MovieCard(movie: movie);
  }

  Future addMovie(String name, String director, String posterPath) async {
    final movie = Movie()
      ..name = name
      ..director = director
      ..posterPath = posterPath;

    final box = Boxes.getMovie();
    box.add(movie);
  }




}
