class BlocObject {
  const BlocObject(this.blocId, this.blocType)
      : assert(blocId != null && blocType != null);
  final String blocId, blocType;
}
