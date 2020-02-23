import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  @override
  ScheduleState get initialState => InitialScheduleState();

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
