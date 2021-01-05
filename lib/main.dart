import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  //for date format

void main() => runApp(MyApp());

final hour = new DateFormat('HH:mm');
final day = new DateFormat('E d y');
final duration = new Duration(days: 1);

DateTime currentDateTime = DateTime.utc(2020,12,29);
DateTime nextDateTime = DateTime.utc(2020,12,30);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassR Calendar',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('ClassR Calendar')),
        body: Column(
          children: [
            _buildSelector,
            _buildBody(context),
          ],
        )
    );
  }


  Widget _buildSelector = Container(
    padding: const EdgeInsets.all(32),
    child : Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            padding: EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.keyboard_arrow_left),
            color: Colors.red[500],
          ),
        ),
        Text(day.format(currentDateTime).toString()),
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            padding: EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.keyboard_arrow_right),
            color: Colors.red[500],
            onPressed: () => currentDateTime.add(duration),
          ),
        ),
      ],
    ),
  );

 Widget _buildBody(BuildContext context) {
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('timeslot').where('timeslot_begin', isGreaterThanOrEqualTo: Timestamp.fromDate(currentDateTime), isLessThan: Timestamp.fromDate(nextDateTime)).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );

  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: Text('${hour.format(record.timeslot_begin).toString()} - ${hour.format(record.timeslot_end).toString()}'),
          title: Text(record.timeslot_course),
          subtitle: Text('${record.timeslot_user}, ${record.timeslot_group}'),
          trailing: Text(record.timeslot_room),
          onTap: () => print(record),
        ),
      ),
    );
  }
}

class Record {
  final String timeslot_course;
  final String timeslot_group;
  final String timeslot_room;
  final String timeslot_user;
  final DateTime timeslot_begin;
  final DateTime timeslot_end;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['timeslot_course'] != null),
        assert(map['timeslot_group'] != null),
        assert(map['timeslot_user'] != null),
        assert(map['timeslot_room'] != null),
        assert(map['timeslot_begin'] != null),
        assert(map['timeslot_end'] != null),
        timeslot_user = map['timeslot_user'],
        timeslot_room = map['timeslot_room'],
        timeslot_group = map['timeslot_group'],
        timeslot_begin = map['timeslot_begin'].toDate(),
        timeslot_end = map['timeslot_end'].toDate(),
        timeslot_course = map['timeslot_course'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$timeslot_course:$timeslot_room, $timeslot_group, $timeslot_user>";
}
