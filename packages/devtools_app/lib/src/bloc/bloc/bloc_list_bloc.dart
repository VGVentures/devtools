import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:vm_service/vm_service.dart';

import '../../eval_on_dart_library.dart';
import '../models/bloc_node.dart';

import 'bloc_list_event.dart';
import 'bloc_list_state.dart';

class BlocListBloc extends Bloc<BlocListEvent, BlocListState> {
  BlocListBloc(this.evalOnDartLibrary, this.service)
      : super(const BlocListState()) {
    subscription = service.onExtensionEvent.where((event) {
      return event.extensionKind == 'bloc:bloc_map_changed';
    }).listen((_) {
      add(BlocListRequested());
    });
  }

  final isAlive = Disposable();
  final EvalOnDartLibrary evalOnDartLibrary;
  final VmService service;
  StreamSubscription<void> subscription;

  @override
  Future<void> close() {
    subscription.cancel();
    isAlive.dispose();
    return super.close();
  }

  @override
  Stream<BlocListState> mapEventToState(
    BlocListEvent event,
  ) async* {
    if (event is BlocListRequested) {
      yield* _mapBlocListRequestedToState(event);
    }
  }

  Stream<BlocListState> _mapBlocListRequestedToState(
      BlocListRequested event,) async* {
    try {
      final List<BlocNode> blocList = await _getBlocList();
      yield BlocListState(blocs: blocList, status: BlocListStatus.success);
    } catch (_) {
      yield state.copyWith(status: BlocListStatus.failure);
    }
  }

  // Creates and populates a List<BlocNode> which holds BlocNodes that serve as references to the active blocs in the attached application.
  Future<List<BlocNode>> _getBlocList() async {
    final blocMapRef = await evalOnDartLibrary.safeEval('Bloc.observer.blocMap',
        isAlive: isAlive);
    final blocMap = await evalOnDartLibrary.getInstance(blocMapRef, isAlive);
    return blocMap.associations
      .where((a) => a.key is! Sentinel && a.value is! Sentinel)
      .map((a) => BlocNode(a.key.valueAsString, a.value.classRef.name))
      .toList();
  }
}
