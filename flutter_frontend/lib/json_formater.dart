import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonViewer extends StatefulWidget {
  final dynamic jsonData;
  final bool initiallyExpanded;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const JsonViewer({
    Key? key,
    required this.jsonData,
    this.initiallyExpanded = true,
    this.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  @override
  State<JsonViewer> createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  late String _prettyJson;

  @override
  void initState() {
    super.initState();
    _prettyJson = _getPrettyJson(widget.jsonData);
  }

  String _getPrettyJson(dynamic json) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  Widget _buildJsonTree(dynamic data, [int depth = 0]) {
    if (data == null) {
      return _buildLeafNode('null', Colors.grey);
    }

    if (data is String) {
      return _buildLeafNode('"$data"', Colors.green);
    }

    if (data is num) {
      return _buildLeafNode(data.toString(), Colors.blue);
    }

    if (data is bool) {
      return _buildLeafNode(data.toString(), Colors.orange);
    }

    if (data is List) {
      return _buildListNode(data, depth);
    }

    if (data is Map) {
      return _buildMapNode(data, depth);
    }

    return _buildLeafNode(data.toString(), Colors.grey);
  }

  Widget _buildLeafNode(String content, Color color) {
    return Text(
      content,
      style: widget.textStyle?.copyWith(color: color) ??
          TextStyle(color: color, fontSize: 14),
    );
  }

  Widget _buildListNode(List data, int depth) {
    return ExpandableNode(
      initiallyExpanded: widget.initiallyExpanded,
      header: '[',
      footer: ']',
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: EdgeInsets.only(left: (depth + 1) * 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$i: ',
                  style: widget.textStyle ?? const TextStyle(fontSize: 14),
                ),
                Expanded(child: _buildJsonTree(data[i], depth + 1)),
                if (i < data.length - 1) const Text(','),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMapNode(Map data, int depth) {
    return ExpandableNode(
      initiallyExpanded: widget.initiallyExpanded,
      header: '{',
      footer: '}',
      children: [
        for (var entry in data.entries)
          Padding(
            padding: EdgeInsets.only(left: (depth + 1) * 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${entry.key}": ',
                  style: widget.textStyle?.copyWith(color: Colors.purple) ??
                      const TextStyle(color: Colors.purple, fontSize: 14),
                ),
                Expanded(child: _buildJsonTree(entry.value, depth + 1)),
                if (entry.key != data.entries.last.key) const Text(','),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _prettyJson));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('JSON copied to clipboard')),
                  );
                },
                tooltip: 'Copy JSON',
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildJsonTree(widget.jsonData),
          ),
        ],
      ),
    );
  }
}

class ExpandableNode extends StatefulWidget {
  final bool initiallyExpanded;
  final String header;
  final String footer;
  final List<Widget> children;

  const ExpandableNode({
    Key? key,
    required this.initiallyExpanded,
    required this.header,
    required this.footer,
    required this.children,
  }) : super(key: key);

  @override
  State<ExpandableNode> createState() => _ExpandableNodeState();
}

class _ExpandableNodeState extends State<ExpandableNode> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Row(
            children: [
              Icon(
                _isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 20,
              ),
              Text(widget.header),
              if (!_isExpanded && widget.children.isNotEmpty)
                const Text(' ... '),
              if (!_isExpanded) Text(widget.footer),
            ],
          ),
        ),
        if (_isExpanded) ...[
          ...widget.children,
          Text(widget.footer),
        ],
      ],
    );
  }
}
