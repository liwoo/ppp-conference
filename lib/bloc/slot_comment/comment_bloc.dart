import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  @override
  CommentState get initialState => InitialCommentState();

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
