import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object?> get props => [];
}

class HabitInitial extends HabitState {
  const HabitInitial();
}

class HabitLoading extends HabitState {
  const HabitLoading();
}

class HabitLoaded extends HabitState {
  const HabitLoaded(this.habits);

  final List<Habit> habits;

  @override
  List<Object?> get props => [habits];
}

class HabitError extends HabitState {
  const HabitError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
