import 'package:equatable/equatable.dart';

abstract class BlocListEvent extends Equatable {
  const BlocListEvent();

  @override
  List<Object> get props => [];
}

class BlocListRequested extends BlocListEvent {}

class BlocSelected extends BlocListEvent {
  const BlocSelected(this.selectedBlocId);

  final String selectedBlocId;

  @override
  List<Object> get props => [selectedBlocId];
}

class BlocListUpdated extends BlocListEvent {
  const BlocListUpdated();
}
