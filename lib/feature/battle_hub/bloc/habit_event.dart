import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabits extends HabitEvent {
  const LoadHabits();
}

class HabitsUpdated extends HabitEvent {
  const HabitsUpdated(this.habits);
  final List<Habit> habits;

  @override
  List<Object?> get props => [habits];
}

class LogHabit extends HabitEvent {
  const LogHabit({
    required this.id,
    required this.isPositive,
  });

  final String id;
  final bool isPositive;

  @override
  List<Object?> get props => [id, isPositive];
}

class CreateHabit extends HabitEvent {
  const CreateHabit({
    required this.title,
    this.isPositive = true,
    this.isNegative = false,
    this.id,
  });

  final String title;
  final bool isPositive;
  final bool isNegative;
  final String? id;

  @override
  List<Object?> get props => [title, isPositive, isNegative, id];
}

class DeleteHabit extends HabitEvent {
  const DeleteHabit(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
