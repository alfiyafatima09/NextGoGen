// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class JsonViewer extends StatefulWidget {
  final dynamic jsonData;
  final bool initiallyExpanded;

  const JsonViewer({
    super.key,
    required this.jsonData,
    this.initiallyExpanded = false,
  });

  @override
  _JsonViewerState createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  late Map<String, bool> _expandedMap;

  @override
  void initState() {
    super.initState();
    _expandedMap = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('JSON Viewer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () => _copyToClipboard(context),
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey),
          ),
          constraints: BoxConstraints(
              maxWidth: 800,
              maxHeight: MediaQuery.of(context).size.height - 100),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildJsonTree(widget.jsonData, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJsonTree(dynamic data, int depth) {
    if (data == null) {
      return _buildLeafNode('null', Colors.black);
    } else if (data is String) {
      return _buildLeafNode('"$data"', Colors.green[700]!);
    } else if (data is num) {
      return _buildLeafNode(data.toString(), Colors.blue[300]!);
    } else if (data is bool) {
      return _buildLeafNode(data.toString(), Colors.orange[300]!);
    } else if (data is List) {
      return _buildListNode(data, depth);
    } else if (data is Map) {
      return _buildMapNode(data.cast<String, dynamic>(), depth);
    }
    return _buildLeafNode(data.toString(), Colors.red[300]!);
  }

  Widget _buildLeafNode(String value, Color color) {
    return Text(
      value,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildListNode(List list, int depth) {
    String key = list.hashCode.toString();
    bool isExpanded = _expandedMap[key] ?? widget.initiallyExpanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedMap[key] = !isExpanded;
            });
          },
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                color: Colors.black54,
              ),
              Text(
                '[${list.length}]',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list
                  .asMap()
                  .entries
                  .map((entry) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key}: ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          Expanded(
                              child: _buildJsonTree(entry.value, depth + 1)),
                        ],
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildMapNode(Map<String, dynamic> map, int depth) {
    String key = map.hashCode.toString();
    bool isExpanded = _expandedMap[key] ?? widget.initiallyExpanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedMap[key] = !isExpanded;
            });
          },
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                color: Colors.black54,
              ),
              Text(
                '{${map.length}}',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: map.entries.map((entry) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"${entry.key}": ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Expanded(child: _buildJsonTree(entry.value, depth + 1)),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    final jsonString =
        const JsonEncoder.withIndent('  ').convert(widget.jsonData);
    Clipboard.setData(ClipboardData(text: jsonString));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON copied to clipboard')),
    );
  }
}
