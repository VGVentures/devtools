import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:vm_service/vm_service.dart';

import '../../eval_on_dart_library.dart';

import 'bloc_list_event.dart';
import 'bloc_node_state.dart';

class BlocNodeBloc extends Bloc<BlocListEvent, BlocNodeState> {
  BlocNodeBloc(
    this.evalOnDartLibrary,
    this.service
  ) : super(const BlocNodeState()) {
    subscription = service.onExtensionEvent.where((event) {
      return event.extensionKind == 'bloc:bloc_map_changed';
    }).listen((_) => add(BlocListUpdated()));
  }
  StreamSubscription subscription;
  final VmService service;
  final EvalOnDartLibrary evalOnDartLibrary;
  final isAlive = Disposable();

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  @override
  Stream<BlocNodeState> mapEventToState(
    BlocListEvent event,
  ) async* {
    if (event is BlocSelected) {
      yield* _mapBlocSelectedToState(event);
    } else if (event is BlocListUpdated) {
      if (state.selectedBlocId == null) return;
      try {
        final Instance blocState = await _getBlocState(state.selectedBlocId);
        yield state.copyWith(
            selectedBlocId: state.selectedBlocId, selectedBlocState: blocState,);
      } catch (_) {}
    }
  }

  Stream<BlocNodeState> _mapBlocSelectedToState(BlocSelected event) async* {
    try {
      final Instance blocState = await _getBlocState(event.selectedBlocId);
      yield state.copyWith(
          selectedBlocId: event.selectedBlocId, selectedBlocState: blocState);
    } catch (e) {
      print(e);
    }
  }


  // Returns an Instance of the state object for the bloc that maps to selectedBlocId
  Future<Instance> _getBlocState(String selectedBlocId) async {
    final blocStateRef = await evalOnDartLibrary.eval(
        'Bloc.observer.blocMap["$selectedBlocId"]?.state',
        isAlive: isAlive);
    final blocState =
        await evalOnDartLibrary.getInstance(blocStateRef, isAlive);

    return blocState;
  }

}
