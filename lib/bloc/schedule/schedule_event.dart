import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScheduleEvent extends Equatable {
  ScheduleEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitializeSchedule extends ScheduleEvent {
  final String attendeeId;

  InitializeSchedule(this.attendeeId): super([attendeeId]);
}


