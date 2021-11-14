import 'package:air_pollution_app/repositories/google_places_repo.dart';
import 'package:flutter/material.dart';
import 'package:air_pollution_app/blocs/google_places_cubit/google_places_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchField extends StatefulWidget {
  final Function(String) onSubmitted;

  const SearchField({
    required this.onSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textEditingController,
          onSubmitted: (String value) {
            if (value.isNotEmpty) {
              widget.onSubmitted(value);
              textEditingController.clear();
            }
          },
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search for place',
            hintStyle: TextStyle(fontSize: 15, color: Colors.white),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
