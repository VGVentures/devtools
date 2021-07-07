import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets.dart';
import '../../inspector/inspector_tree.dart';
import '../../split.dart';
import '../../theme.dart';
import '../bloc/bloc_list_event.dart';
import '../bloc/bloc_node_bloc.dart';
import '../instance_viewer/instance_details.dart';
import '../instance_viewer/instance_viewer.dart';
import '../models/bloc_node.dart';

class BlocListView extends StatelessWidget {
  const BlocListView(this._blocs, {Key key}) : super(key: key);

  final List<BlocNode> _blocs;

  @override
  Widget build(BuildContext context) {
    final splitAxis = Split.axisFor(context, 0.85);
    final selectedBlocState = context.watch<BlocNodeBloc>().state;
    final selectedBlocId = selectedBlocState.selectedBlocId;

    return Split(axis: splitAxis, initialFractions: const [
      0.33,
      0.67
    ], children: [
      OutlineDecoration(
          child: Column(children: [
        const AreaPaneHeader(
          title: Text('Blocs'),
          needsTopBorder: false,
        ),
        Expanded(child: BlocList(_blocs))
      ])),
      OutlineDecoration(
          child: Column(children: [
        const AreaPaneHeader(
          title: Text('TITLE TO BE ADDED'),
          needsTopBorder: false,
        ),
        if (selectedBlocId != null)
          Expanded(
            child: InstanceViewer(
              rootPath: InstancePath.fromBlocId(selectedBlocId),
              showInternalProperties: true,
            ),
          )
      ]))
    ]);
  }
}

class BlocList extends StatefulWidget {
  const BlocList(this._blocs, {Key key}) : super(key: key);
  final List<BlocNode> _blocs;

  @override
  _BlocListState createState() => _BlocListState();
}

class _BlocListState extends State<BlocList> {
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
              return BlocNodeView(widget._blocs[index]);
            }));
  }
}

const _tilePadding = EdgeInsets.only(
  left: defaultSpacing,
  right: densePadding,
  top: densePadding,
  bottom: densePadding,
);

class BlocNodeView extends StatelessWidget {
  const BlocNodeView(this._bloc, {Key key}) : super(key: key);

  final BlocNode _bloc;

  @override
  Widget build(BuildContext context) {
    final blocState = context.read<BlocNodeBloc>().state;
    final isSelected = blocState.selectedBlocId == _bloc.blocId;
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor =
        isSelected ? colorScheme.selectedRowBackgroundColor : null;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            context.read<BlocNodeBloc>().add(BlocSelected(_bloc.blocId)),
        child: Container(
            color: backgroundColor,
            padding: _tilePadding,
            child: Text('${_bloc.blocType}()')));
  }
}