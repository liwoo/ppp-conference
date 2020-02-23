import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category({
    Key key,
    @required this.title,
    @required this.color,
  }) : super(key: key);

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text(
        title,
        style: Theme.of(context).textTheme.caption.copyWith(color: color),
      ),
    );
  }
}