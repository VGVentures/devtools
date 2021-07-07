import 'package:vm_service/src/vm_service.dart';

class BlocNodeState {
  const BlocNodeState({this.selectedBlocId, this.selectedBlocState});

  final String selectedBlocId;
  final Instance selectedBlocState;

  BlocNodeState copyWith({
    String selectedBlocId,
    Instance selectedBlocState,
  }) {
    return BlocNodeState(
      selectedBlocId: selectedBlocId ?? this.selectedBlocId,
      selectedBlocState: selectedBlocState ?? this.selectedBlocState,
    );
  }
}