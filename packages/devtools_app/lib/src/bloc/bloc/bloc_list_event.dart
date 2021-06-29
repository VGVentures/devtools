part of 'bloc_list_bloc.dart';

abstract class BlocListEvent {
  const BlocListEvent();
}

class BlocListRequested extends BlocListEvent {
  const BlocListRequested();
}

class BlocSelected extends BlocListEvent {
  const BlocSelected(this.selectedBlocId);

  final String selectedBlocId;
}
