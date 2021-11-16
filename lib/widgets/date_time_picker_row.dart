import 'package:flutter/material.dart';

class DateTimePickerRow extends StatelessWidget {
  final Function(DateTime) onDataFromChanged;
  final Function(DateTime) onDataToChanged;

  const DateTimePickerRow({
    required this.onDataFromChanged,
    required this.onDataToChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateNow = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            Text('Pick start date'),
            SizedBox(
              height: 200,
              width: 300,
              child: CalendarDatePicker(
                initialDate: dateNow,
                firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                lastDate: DateTime.utc(2030),
                onDateChanged: onDataFromChanged,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            Text('Pick end date'),
            SizedBox(
              height: 200,
              width: 300,
              child: CalendarDatePicker(
                initialDate: dateNow,
                firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                lastDate: DateTime.utc(2030),
                onDateChanged: onDataToChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
