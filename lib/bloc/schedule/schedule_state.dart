import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ppp_conference/models/slot.dart';
import 'package:ppp_conference/screens/schedule/widgets/category.dart';

@immutable
abstract class ScheduleState extends Equatable{
  ScheduleState([List props = const []]);

  @override
  List<Object>  get props => [];
}

class InitialScheduleState extends ScheduleState {}

class LoadingScheduleState extends ScheduleState {
  @override
  String toString() {
    return 'Loading Schedule...';
  }

  @override
  List<Object> get props => [];
}

class LoadedScheduleState extends ScheduleState {
  final List<Slot> dayOneSlots;
  final List<Slot> dayTwoSlots;
  final List<Slot> dayThreeSlots;

  LoadedScheduleState(this.dayOneSlots, this.dayTwoSlots, this.dayThreeSlots): super([dayOneSlots, dayTwoSlots, dayThreeSlots]);

  @override
  List<Object> get props => [dayOneSlots, dayTwoSlots, dayThreeSlots];
}

class FailedLoadingScheduleState extends ScheduleState {
  @override
  String toString() {
    return 'Could not Load Schedule at this time';
  }

  @override
  List<Object> get props => [];
}

