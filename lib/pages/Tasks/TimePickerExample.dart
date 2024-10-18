import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DurationPicker extends StatefulWidget {
  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int days = 0;
  int months = 0;
  int hours = 0;
  int minutes = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Duration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Months'),
                  NumberPicker(
                    value: months,
                    minValue: 0,
                    maxValue: 12, // Assuming a max of 12 months
                    onChanged: (value) {
                      setState(() {
                        months = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Days'),
                  NumberPicker(
                    value: days,
                    minValue: 0,
                    maxValue: 30, // Assuming a max of 30 days
                    onChanged: (value) {
                      setState(() {
                        days = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Hours'),
                  NumberPicker(
                    value: hours,
                    minValue: 0,
                    maxValue: 24,
                    onChanged: (value) {
                      setState(() {
                        hours = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Minutes'),
                  NumberPicker(
                    value: minutes,
                    minValue: 0,
                    maxValue: 59,
                    onChanged: (value) {
                      setState(() {
                        minutes = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, Duration(
                days: days,
                hours: hours,
                minutes: minutes,
              ));
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}
