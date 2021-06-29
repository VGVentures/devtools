part of 'bloc_list_bloc.dart';

abstract class BlocListState {
  const BlocListState();
}

class BlocListInitial extends BlocListState {
  const BlocListInitial();
}

class BlocListLoadInProgress extends BlocListState {
  const BlocListLoadInProgress();
}

class BlocListLoadSuccess extends BlocListState {
  const BlocListLoadSuccess(this.blocs, [this.selectedBlocId])
      : assert(blocs != null);

  final List<BlocObject> blocs;
  final String selectedBlocId;
}

class BlocListLoadFailure extends BlocListState {
  const BlocListLoadFailure();
}
