
class Tool {
  final String tool_name;
  final num tool_id;

  Tool.fromMap(Map<String, dynamic> map)
      : assert(map['tool_name'] != null),
        assert(map['tool_id'] != null),
        tool_name = map['tool_name'],
        tool_id = map['tool_id'];

  @override
  String toString() => "Tool<$tool_name:$tool_id>";
}