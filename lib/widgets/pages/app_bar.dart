import 'package:air_pollution_app/widgets/search_field.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function(String)? onSubmitted;
  final bool isHomePage;

  const CustomAppBar({
    this.onSubmitted,
    this.isHomePage = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('Air pollution'),
            SizedBox(
              width: 500,
              child: SearchField(
                onSubmitted: onSubmitted!,
              ),
            ),
          if (isHomePage)
            IconButton(
              icon: const Icon(Icons.insert_chart),
              onPressed: () {
                Navigator.pushNamed(context, '/charts');
              },
            )
          else
            const SizedBox(width: 60)
        ],
      ),
      elevation: 8,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
