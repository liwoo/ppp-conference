import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ppp_conference/models/comment.dart';
import 'package:ppp_conference/repositories/user_schedule_repository.dart';
import './bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  IUserScheduleRepository userScheduleRepository;

  CommentBloc({@required this.userScheduleRepository});

  @override
  CommentState get initialState => LoadingCommentsState();

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    if(event is InitializeComments) {
      try {
        List<SlotComment> comments = await userScheduleRepository.fetchSlotComments(event.slotId);
        yield LoadedCommentsState(comments);
      } catch (e) {
        print(e);
        yield FailedLoadingCommentsState();
      }
    }
  }
}
