import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CommentEvent extends Equatable {
  CommentEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitializeComments extends CommentEvent {
  final String slotId;

  InitializeComments(this.slotId): super([slotId]);
}

class SendComment extends CommentEvent {
  final String commenterId;
  final String comment;
  final String slotId;

  SendComment(this.commenterId, this.comment, this.slotId): super([commenterId, comment]);
}