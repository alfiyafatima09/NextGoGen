import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class SyntaxHighlighter {
  TextSpan format(String source);
}

class JsonFormatter {
  static String prettyJson(dynamic json) {
    var spaces = ' ' * 2;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }
}

class JsonSyntaxHighlighter extends SyntaxHighlighter {
  JsonSyntaxHighlighter({
    this.stringColor = const Color(0xFF00B7C3),
    this.numberColor = const Color(0xFF1A88FF),
    this.booleanColor = const Color(0xFF0033B3),
    this.nullColor = const Color(0xFF808080),
    this.symbolColor = const Color(0xFF000000),
  });

  final Color stringColor;
  final Color numberColor;
  final Color booleanColor;
  final Color nullColor;
  final Color symbolColor;

  @override
  TextSpan format(String source) {
    List<TextSpan> spans = [];
    StringBuffer buffer = StringBuffer();

    void addNormalText() {
      if (buffer.isNotEmpty) {
        spans.add(TextSpan(
            text: buffer.toString(), style: TextStyle(color: symbolColor)));
        buffer.clear();
      }
    }

    bool inString = false;
    bool escaped = false;

    for (int i = 0; i < source.length; i++) {
      String char = source[i];

      if (inString) {
        if (escaped) {
          buffer.write(char);
          escaped = false;
          continue;
        }

        if (char == '\\') {
          buffer.write(char);
          escaped = true;
          continue;
        }

        if (char == '"') {
          buffer.write(char);
          spans.add(TextSpan(
              text: buffer.toString(), style: TextStyle(color: stringColor)));
          buffer.clear();
          inString = false;
          continue;
        }

        buffer.write(char);
        continue;
      }

      if (char == '"') {
        addNormalText();
        buffer.write(char);
        inString = true;
        continue;
      }

      // Handle numbers
      if (RegExp(r'[0-9]').hasMatch(char)) {
        if (buffer.isEmpty || RegExp(r'[0-9\.-]').hasMatch(buffer.toString())) {
          buffer.write(char);
          continue;
        }
        addNormalText();
        buffer.write(char);
        continue;
      }

      if (buffer.isNotEmpty &&
          RegExp(r'[0-9\.-]').hasMatch(buffer.toString())) {
        spans.add(TextSpan(
            text: buffer.toString(), style: TextStyle(color: numberColor)));
        buffer.clear();
      }

      // Handle boolean and null
      if (RegExp(r'[tfn]').hasMatch(char)) {
        if (buffer.isEmpty) {
          buffer.write(char);
          continue;
        }
        if (buffer.toString() + char == 'true' ||
            buffer.toString() + char == 'false') {
          buffer.write(char);
          spans.add(TextSpan(
              text: buffer.toString(), style: TextStyle(color: booleanColor)));
          buffer.clear();
          continue;
        }
        if (buffer.toString() + char == 'null') {
          buffer.write(char);
          spans.add(TextSpan(
              text: buffer.toString(), style: TextStyle(color: nullColor)));
          buffer.clear();
          continue;
        }
        buffer.write(char);
        continue;
      }

      addNormalText();
      buffer.write(char);
    }

    addNormalText();
    return TextSpan(children: spans);
  }
}

// abstract class SyntaxHighlighter {
//   TextSpan format(String src);
// }

// class JsonFormatter {
//   static String prettyJson(dynamic json) {
//     const JsonEncoder encoder = JsonEncoder.withIndent('  ');
//     return encoder.convert(json);
//   }

//   static void copyJson(BuildContext context, dynamic json) {
//     // Copy as formatted JSON rather than raw string
//     const JsonEncoder encoder = JsonEncoder.withIndent('  ');
//     String formattedJson = encoder.convert(json);
//     Clipboard.setData(ClipboardData(text: formattedJson));
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('JSON copied to clipboard')),
//     );
//   }
// }

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
    return SingleChildScrollView(
      child: Container(
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
