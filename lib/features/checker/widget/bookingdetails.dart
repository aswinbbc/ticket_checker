import 'package:flutter/material.dart';

class BookingDetailsWidget extends StatelessWidget {
  const BookingDetailsWidget({
    Key? key,
    required this.eventName,
    required this.concertDate,
    required this.seatNumber,
  }) : super(key: key);

  final String eventName;
  final String concertDate;
  final String seatNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Event Name",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(eventName,
                  style: const TextStyle(
                    fontSize: 15,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text(concertDate,
                    style: const TextStyle(
                      fontSize: 15,
                    ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("No of Seats",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(seatNumber,
                  style: const TextStyle(
                    fontSize: 15,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
