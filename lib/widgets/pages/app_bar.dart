import 'package:air_pollution_app/widgets/search_field.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function(String) onSubmitted;

  const CustomAppBar({required this.onSubmitted, Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          Text('Air pollution'),
          SizedBox(width: 500),
          SizedBox(
            width: 500,
            child: SearchField(
              onSubmitted:onSubmitted,
            ),
          ),
          TextButton(
            child: Text(
              'Go to charts page',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/charts');
            },
          ),
        ],
      ),
      elevation: 8,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
