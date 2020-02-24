import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppp_conference/models/comment.dart';

class CommentList extends StatelessWidget {
  const CommentList({
    Key key,
    @required this.context,
    @required this.myComments,
    @required this.color,
    @required this.slotId,
  }) : super(key: key);

  final BuildContext context;
  final List<SlotComment> myComments;
  final Color color;
  final String slotId;

  @override
  Widget build(BuildContext context) {
    var commentList = myComments.map((comment) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          children: <Widget>[
            Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(99))),
                child: Text(
                  'IM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 18,
            ),
            Flexible(
              child: RichText(
                text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.bold),
                    text: '${comment.commenter} ',
                    children: [
                      TextSpan(
                          style: Theme.of(context).textTheme.body1,
                          text: comment.comment)
                    ]),
              ),
            )
          ],
        ),
      );
    }).toList();

    return Column(
        children: commentList
    );
  }
}

var comments = [
  SlotComment(
      comment: 'This is a really good thing, I am in total support! 😀',
      commenter: 'Linda Nyongo',
      time: DateTime(2020, 2, 24, 9, 14, 22)),
  SlotComment(
      comment:
      'Really enjoying these sessions... Would love to hear more about this topic',
      commenter: 'Lucy Mwalwimba',
      time: DateTime(2020, 2, 24, 9, 27, 18)),
  SlotComment(
      comment:
      'Big up to you gius for such a wonderful experience we are having over here. Big up to the developer as well...',
      commenter: 'Enipher Chiguduli',
      time: DateTime(2020, 2, 24, 9, 29, 7)),
  SlotComment(
      comment: 'This is a really good thing, I am in total support! 😀',
      commenter: 'Linda Nyongo',
      time: DateTime(2020, 2, 24, 9, 14, 22)),
  SlotComment(
      comment:
      'Really enjoying these sessions... Would love to hear more about this topic',
      commenter: 'Lucy Mwalwimba',
      time: DateTime(2020, 2, 24, 9, 27, 18)),
  SlotComment(
      comment:
      'Big up to you gius for such a wonderful experience we are having over here. Big up to the developer as well...',
      commenter: 'Enipher Chiguduli',
      time: DateTime(2020, 2, 24, 9, 29, 7)),
  SlotComment(
      comment: 'This is a really good thing, I am in total support! 😀',
      commenter: 'Linda Nyongo',
      time: DateTime(2020, 2, 24, 9, 14, 22)),
  SlotComment(
      comment:
      'Really enjoying these sessions... Would love to hear more about this topic',
      commenter: 'Lucy Mwalwimba',
      time: DateTime(2020, 2, 24, 9, 27, 18)),
  SlotComment(
      comment:
      'Big up to you gius for such a wonderful experience we are having over here. Big up to the developer as well...',
      commenter: 'Enipher Chiguduli',
      time: DateTime(2020, 2, 24, 9, 29, 7))
];