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
  final SlotComment newComment;
  final List<SlotComment> previousComments;
  final String slotId;

  SendingCommentState(this.newComment, this.slotId, this.previousComments): super([newComment, slotId, previousComments]);

  @override
  List<Object> get props => [newComment, slotId, previousComments];

  @override
  String toString() {
    return 'Sending Comment...';
  }
}

class SentCommentState extends CommentState {
  final List<SlotComment> newComments;
  final String slotId;

  SentCommentState(this.newComments, this.slotId): super([newComments, slotId]);

  @override
  List<Object> get props => [newComments, slotId];

  @override
  String toString() {
    return 'Comment Sent';
  }
}

class FailedSendingCommentState extends CommentState {
  final List<SlotComment> oldComments;
  final String slotId;

  FailedSendingCommentState(this.oldComments, this.slotId): super([oldComments, slotId]);

  @override
  List<Object> get props => [oldComments, slotId];

  @override
  String toString() {
    return 'Comment Failed to Send';
  }
}



