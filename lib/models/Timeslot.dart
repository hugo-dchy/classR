import 'package:cloud_firestore/cloud_firestore.dart';

class Timeslot {
  final String timeslot_course;
  final String timeslot_group;
  final String timeslot_room;
  final int timeslot_roomId;
  final String timeslot_user;
  final int timeslot_id;
  final DateTime timeslot_begin;
  final DateTime timeslot_end;
  final DocumentReference reference;

  Timeslot.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['timeslot_course'] != null),
        assert(map['timeslot_group'] != null),
        assert(map['timeslot_user'] != null),
        assert(map['timeslot_room'] != null),
        assert(map['timeslot_roomId'] != null),
        assert(map['timeslot_id'] != null),
        assert(map['timeslot_begin'] != null),
        assert(map['timeslot_end'] != null),
        timeslot_user = map['timeslot_user'],
        timeslot_room = map['timeslot_room'],
        timeslot_group = map['timeslot_group'],
        timeslot_id = map['timeslot_id'],
        timeslot_roomId = map['timeslot_roomId'],
        timeslot_begin = map['timeslot_begin'].toDate(),
        timeslot_end = map['timeslot_end'].toDate(),
        timeslot_course = map['timeslot_course'];

  Timeslot.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Timeslot<$timeslot_course:$timeslot_room, $timeslot_group, $timeslot_user>";
}