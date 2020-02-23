import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ppp_conference/models/comment.dart';

@immutable
abstract class CommentState extends Equatable{
  CommentState([List props = const []]);

  @override
  List<Object>  get props => [];
}

class InitialCommentState extends CommentState {}

class LoadingCommentsState extends CommentState {
  @override
  String toString() {
    return 'Loading Comments...';
  }

  @override
  List<Object> get props => [];
}

class LoadedCommentsState extends CommentState {
  final List<SlotComment> slotComments;

  LoadedCommentsState(this.slotComments): super([slotComments]);

  @override
  List<Object> get props => [slotComments];
}

class FailedLoadingCommentsState extends CommentState {
  @override
  String toString() {
    return 'Could not Load Comments at this time';
  }

  @override
  List<Object> get props => [];
}

class SendingCommentState extends CommentState {
  final SlotComment comment;
  final String slotId;

  SendingCommentState(this.comment, this.slotId): super([comment, slotId]);

  @override
  List<Object> get props => [comment, slotId];

  @override
  String toString() {
    return 'Sending Comment...';
  }
}

class SentCommentState extends CommentState {
  final SlotComment comment;
  final String slotId;

  SentCommentState(this.comment, this.slotId): super([comment, slotId]);

  @override
  List<Object> get props => [comment, slotId];

  @override
  String toString() {
    return 'Comment Sent';
  }
}

class FailedSendingCommentState extends CommentState {
  final SlotComment comment;
  final String slotId;

  FailedSendingCommentState(this.comment, this.slotId): super([comment, slotId]);

  @override
  List<Object> get props => [comment, slotId];

  @override
  String toString() {
    return 'Comment Failed to Send';
  }
}



