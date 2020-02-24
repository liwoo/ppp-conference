import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ppp_conference/bloc/auth/bloc.dart';
import 'package:ppp_conference/models/comment.dart';
import 'package:ppp_conference/repositories/auth_repository.dart';
import 'package:ppp_conference/repositories/user_schedule_repository.dart';
import './bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  IUserScheduleRepository userScheduleRepository;
  AuthBloc authBloc;

  CommentBloc({@required this.userScheduleRepository, @required this.authBloc});

  @override
  CommentState get initialState => LoadingCommentsState();

  CommentState get currentState => this.state;

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

    if(event is SendComment) {
//      var user = (authBlocloc.state as LoggedInState).user;
      var currentComments = (currentState as LoadedCommentsState).slotComments;
      var commenter = 'Anonymous User';//user.displayName ?? user.phoneNumber ?? 'Anonymous';
      var commenterImage = '';//user.photoUrl;
      var commenterID = 'generic';//user.uid;
      var newComment = SlotComment(
        commenterID: commenterID,
        comment: event.comment,
        commenter: commenter, //Get this from Auth bloc
        commenterImage: commenterImage,
        time: DateTime.now()
      );
      yield SendingCommentState(newComment, event.slotId, currentComments);
      try {
        await userScheduleRepository.addComment(event.comment, commenter, event.slotId, event.commenterId);
        yield SentCommentState([...currentComments, newComment], event.slotId);
      } catch (e) {
        print(e);
        yield FailedSendingCommentState(currentComments, event.slotId);
      }
    }
  }
}
