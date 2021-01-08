import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assets/constants.dart';
import '../models/Timeslot.dart';
import 'TimeslotDetail.dart';  //for date format

class TimeslotList extends StatefulWidget {
  @override
  _TimeslotListState createState() {
    return _TimeslotListState();
  }
}

class _TimeslotListState extends State<TimeslotList> {

  DateTime _currentDateTime = DateTime.now();
  Duration _oneDay = new Duration(days: 1);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _currentDateTime,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != _currentDateTime)
      setState(() {
        _currentDateTime = picked;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('ClassR Calendar')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Text("${date.format(_currentDateTime.toLocal()).toString()}"),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
            ),
            _buildBody(context),
          ],
        )
    );
  }



  Widget _buildBody(BuildContext context) {
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('timeslot').where('timeslot_begin', isGreaterThanOrEqualTo: Timestamp.fromDate(_currentDateTime), isLessThan: Timestamp.fromDate(_currentDateTime.add(_oneDay))).snapshots(),
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
    final record = Timeslot.fromSnapshot(data);

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
          onTap: () => _seeTimeslot(record.timeslot_id),
        ),
      ),
    );
  }

  void _seeTimeslot(id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TimeslotDetail(id: id),
      ),
    );
  }
}