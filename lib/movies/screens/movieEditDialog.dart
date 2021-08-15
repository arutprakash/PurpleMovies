import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yellow_movies/movies/model/movie_model.dart';

class movieEditDialog extends StatefulWidget {
  final Movie? movie;
  final Function(String name, String director, String posterPath) onClickedDone;

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
  File? _image1;

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
              buildImage(),
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildDirector(),

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

  Widget buildImage() => Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 120,
        height: 150,
        child: OutlineButton(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.5),
            onPressed: () async {
              // final PickedFile = await ImagePicker().getImage(source: ImageSource.gallery) as Future<File>;
              // // _selectImage();
              // _selectImage(PickedFile);

              final PickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
              _selectImage(File(PickedFile!.path));
            },
            child: _displayChild1()
        ),
      ),
    ),
  );

  void _selectImage(File pickImage) async {
    File tempImg = pickImage;
    setState(() => _image1 = tempImg);
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _image1!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }


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
          final posterPath = _image1!.path;

          widget.onClickedDone(name, director, posterPath);

          Navigator.of(context).pop();
        }
      },
    );
  }






}
