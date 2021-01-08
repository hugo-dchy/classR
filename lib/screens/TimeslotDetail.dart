import 'package:classr/assets/constants.dart';
import 'package:classr/models/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/Timeslot.dart';


class TimeslotDetail extends StatelessWidget  {

  final num id;

  TimeslotDetail({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: _buildBody(context, id),
    );
  }

  Widget _buildBody(BuildContext context, num id) {
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('timeslot').where('timeslot_id', isEqualTo: id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildContent(context, snapshot.data.documents);
      },
    );

  }

  Widget _buildContent(BuildContext context, List<DocumentSnapshot> snapshot) {

    final timeSlot = Timeslot.fromSnapshot(snapshot[0]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:  ListTile(
                  title: Text('${timeSlot.timeslot_course} - ${timeSlot.timeslot_user}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${timeSlot.timeslot_room}',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      Text(
                        '${hour.format(timeSlot.timeslot_begin).toString()} - ${hour.format(timeSlot.timeslot_end).toString()}',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset('images/classroom.jpg'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildRoom(context, timeSlot.timeslot_room),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoom(BuildContext context, String room) {
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('room').where('room_name', isEqualTo: room).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildContentRoom(context, snapshot.data.documents);
      },
    );

  }

  Widget _buildContentRoom(BuildContext context, List<DocumentSnapshot> snapshot) {

    final roomContent = Room.fromSnapshot(snapshot[0]);
    print(roomContent);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text('test')
    );
  }
}