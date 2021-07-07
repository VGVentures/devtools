abstract class BlocListEvent {
  const BlocListEvent();
}

class BlocListRequested extends BlocListEvent {}

class BlocSelected extends BlocListEvent {
  const BlocSelected(this.selectedBlocId);

  final String selectedBlocId;
}

class BlocListUpdated extends BlocListEvent {
  const BlocListUpdated();
}
