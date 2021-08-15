import 'package:flutter/material.dart';
import 'package:yellow_movies/movies/model/movie_model.dart';

class movieEditDialog extends StatefulWidget {
  final Movie? movie;
  final Function(String name, String director) onClickedDone;

  const movieEditDialog({
    Key? key,
    this.movie,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _movieEditDialogState createState() => _movieEditDialogState();
}

class _movieEditDialogState extends State<movieEditDialog> {
  final formKey = GlobalKey<FormState>();
  // List<TextEditingController> myController = List.generate(2, (i) => TextEditingController());
  TextEditingController nameController = TextEditingController();
  TextEditingController directorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      final movie = widget.movie!;

      nameController.text = movie.name;
      directorController.text = movie.director.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    directorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildDirector(),
              // SizedBox(height: 8),
              // buildRadioButtons(),

            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );;
  }

  Widget buildName() => TextFormField(
    controller: nameController,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Enter Name',
    ),
    validator: (name) =>
    name != null && name.isEmpty ? 'Enter a name' : null,
  );

  Widget buildDirector() => TextFormField(
    controller: directorController,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Enter Director',
    ),
    validator: (name) =>
    name != null && name.isEmpty ? 'Director' : null,
  );

  Widget buildCancelButton(BuildContext context) => TextButton(
    child: Text('Cancel'),
    onPressed: () => Navigator.of(context).pop(),
  );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final director = directorController.text;

          widget.onClickedDone(name, director);

          Navigator.of(context).pop();
        }
      },
    );
  }


}
