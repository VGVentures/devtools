import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets.dart';
import '../../inspector/inspector_tree.dart';
import '../../provider/instance_viewer/instance_details.dart';
import '../../provider/instance_viewer/instance_viewer.dart';
import '../../split.dart';
import '../../theme.dart';
import '../bloc/bloc_list_bloc.dart';
import '../models/bloc_object.dart';

class BlocView extends StatelessWidget {
  const BlocView(this._blocs, this._selectedBlocId, {Key key})
      : super(key: key);

  final List<BlocObject> _blocs;
  final String _selectedBlocId;

  @override
  Widget build(BuildContext context) {
    final splitAxis = Split.axisFor(context, 0.85);
    return Split(axis: splitAxis, initialFractions: const [
      0.33,
      0.67
    ], children: [
      // BlocListView
      OutlineDecoration(
          child: Column(children: [
        const AreaPaneHeader(
          title: Text('Blocs'),
          needsTopBorder: false,
        ),
        Expanded(child: BlocListView(_blocs))
      ])),
      // BlocDetailView
      OutlineDecoration(
          child: Column(children: [
        const AreaPaneHeader(
          title: Text('Bloc Detail View'),
          needsTopBorder: false,
        ),
        if (_selectedBlocId != null)
          Expanded(
              child: InstanceViewer(
            showInternalProperties: true,
            rootPath: InstancePath.fromInstanceId(_selectedBlocId),
          ))
      ]))
    ]);
  }
}

class BlocListView extends StatefulWidget {
  const BlocListView(this._blocs, {Key key}) : super(key: key);
  final List<BlocObject> _blocs;

  @override
  _BlocListViewState createState() => _BlocListViewState();
}

class _BlocListViewState extends State<BlocListView> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: ListView.builder(
            primary: false,
            controller: scrollController,
            itemCount: widget._blocs.length,
            itemBuilder: (_, index) {
              return BlocItemView(widget._blocs[index]);
            }));
  }
}

const _tilePadding = EdgeInsets.only(
  left: defaultSpacing,
  right: densePadding,
  top: densePadding,
  bottom: densePadding,
);

class BlocItemView extends StatelessWidget {
  const BlocItemView(this._bloc, {Key key}) : super(key: key);

  final BlocObject _bloc;

  @override
  Widget build(BuildContext context) {
    final blocState = context.read<BlocListBloc>().state;
    if (blocState is! BlocListLoadSuccess) {
      throw Exception('Invalid State');
    }
    final castedBlocState = blocState as BlocListLoadSuccess;
    final isSelected = castedBlocState.selectedBlocId == _bloc.blocId;
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor =
        isSelected ? colorScheme.selectedRowBackgroundColor : null;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            context.read<BlocListBloc>().add(BlocSelected(_bloc.blocId)),
        child: Container(
            color: backgroundColor,
            padding: _tilePadding,
            child: Text('${_bloc.blocType}()')));
  }
}
