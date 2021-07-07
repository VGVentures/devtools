// ignore: implementation_imports
import '../models/bloc_node.dart';

enum BlocListStatus { initial, loading, success, failure }

class BlocListState {
  const BlocListState({
    this.blocs = const [],
    this.status = BlocListStatus.loading,
  }) : assert(blocs != null);

  final List<BlocNode> blocs;
  final BlocListStatus status;

  BlocListState copyWith({
    List<BlocNode> blocs,
    BlocListStatus status,
  }) {
    return BlocListState(
      blocs: blocs ?? this.blocs,
      status: status ?? this.status,
    );
  }
}
