part of 'day_book_bloc.dart';

sealed class DayBookState extends Equatable {
  const DayBookState(this.dayBooks);
  final List<DayBook> dayBooks;

  @override
  List<Object> get props => [dayBooks];
}

final class DayBookInitial extends DayBookState {
  const DayBookInitial(super.dayBooks);
}

final class DayBookLoading extends DayBookState {
  const DayBookLoading(super.dayBooks);
}

final class DayBookLoaded extends DayBookState {
  const DayBookLoaded(super.dayBooks);
}

final class DayBookError extends DayBookState {
  const DayBookError(super.dayBooks, this.error);
  final String error;

  @override
  List<Object> get props => [dayBooks, error];
}
