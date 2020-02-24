import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppp_conference/bloc/slot_comment/bloc.dart';
import 'package:ppp_conference/models/comment.dart';
import 'package:time_formatter/time_formatter.dart';

class CommentList extends StatelessWidget {
  const CommentList({
    Key key,
    @required this.context,
    @required this.color,
    @required this.slotId,
    @required this.bloc
  }) : super(key: key);

  final BuildContext context;
  final CommentBloc bloc;
  final Color color;
  final String slotId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is LoadingCommentsState) {
          return Text('Loading Comments');
        }

        if (state is LoadedCommentsState) {
          return state.slotComments.length == 0
              ? buildEmptyCommentState(context)
              : Column(
                  children: state.slotComments
                      .map((comment) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: buildComment(comment, context),
                          ))
                      .toList());
        }

        if(state is SendingCommentState) {
          return Column(
            children: [
              Opacity(opacity: 0.6, child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: buildComment(state.newComment, context),
              )),
              if(state.previousComments.length > 0)
                ...state.previousComments.map((comment) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  child: buildComment(comment, context),
                )).toList()
            ],
          );
        }

        if(state is SentCommentState) {
          return Column(
            children: state.newComments.map((comment) => Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: buildComment(comment, context),
            )).toList(),
          );
        }

        if(state is FailedSendingCommentState) {
          return Column(
            children: state.oldComments.map((comment) => Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: buildComment(comment, context),
            )).toList(),
          );
        }

        return Text('Could not Load Comments at this time');
      },
    );
  }

  Row buildComment(SlotComment comment, BuildContext context) {
    var splitCommenter = comment.commenter.split(' ');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            width: 30,
            height: 30,
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: splitCommenter.length == 1 ? 10 : 4),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(99))),
            child: Text(
              '${splitCommenter[0][0]}${splitCommenter.length > 1 ? splitCommenter[1][0] : ''}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        SizedBox(
          width: 18,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
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
              SizedBox(height: 8,),
              Text(formatTime(Timestamp.fromDate(comment.time).millisecondsSinceEpoch), style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),)
            ],
          ),
        )
      ],
    );
  }

  Widget buildEmptyCommentState(BuildContext context) => Column(
        children: <Widget>[
          Text(
            '✍🏽',
            style: Theme.of(context).textTheme.display3.copyWith(fontSize: 82),
          ),
          Text(
            'Be the first person to comment on this event',
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      );
}
