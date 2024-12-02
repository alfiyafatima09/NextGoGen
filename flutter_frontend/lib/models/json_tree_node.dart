class JsonTreeNode {
  final String key;
  final dynamic value;
  final int depth;
  final bool isExpanded;

  JsonTreeNode({
    required this.key,
    required this.value,
    required this.depth,
    this.isExpanded = false,
  });
}
