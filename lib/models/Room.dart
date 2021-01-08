import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String room_name;
  final List<dynamic> room_tools;
  final String room_id;
  final DocumentReference reference;

  Room.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['room_name'] != null),
        assert(map['room_tools'] != null),
        assert(map['room_id'] != null),
        room_name = map['room_name'],
        room_tools = map['room_tools'],
        room_id = map['room_id'];

  Room.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Room<$room_name:$room_id>";
}