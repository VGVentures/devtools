class BlocNode {
  BlocNode(this.blocId, this.blocType);
  final String blocId, blocType;
}

class BlocState {
  BlocState({this.fields});

  final Map<String, String> fields;
}