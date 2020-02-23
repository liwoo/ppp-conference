import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ppp_conference/models/slot.dart';
import 'package:ppp_conference/repositories/user_schedule_repository.dart';
import './bloc.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  IUserScheduleRepository userScheduleRepository;

  ScheduleBloc({@required this.userScheduleRepository});

  @override
  ScheduleState get initialState => LoadingScheduleState();

  ScheduleState get currentState => this.state;

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    if (event is InitializeSchedule) {
      try {
        List<Slot> dayOne = await userScheduleRepository.fetchDailySlots(DateTime(2020, 2, 24), event.attendeeId);
        List<Slot> dayTwo = await userScheduleRepository.fetchDailySlots(DateTime(2020, 2, 25), event.attendeeId);
        List<Slot> dayThree = await userScheduleRepository.fetchDailySlots(DateTime(2020, 2, 26), event.attendeeId);
        yield LoadedScheduleState(dayOne, dayTwo, dayThree);
      } catch (e) {
        print(e);
        yield FailedLoadingScheduleState();
      }
    }
  }
}
