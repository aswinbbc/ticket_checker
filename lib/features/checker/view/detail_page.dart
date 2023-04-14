import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:ticket_checker/constants/colors.dart';
import 'package:ticket_checker/dummy_data.dart';
import 'package:ticket_checker/features/checker/model/booking_details_model.dart';
import 'package:ticket_checker/features/checker/widget/bookedname.dart';
import 'package:ticket_checker/features/checker/widget/bookingdetails.dart';
import 'package:ticket_checker/features/checker/widget/bordercard.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.data});

  final BookingDetails data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Center(child: Text("Booked Tickets")),
      ),
      body: TicketDetails(
        ticketModel: data,
      ),
    );
  }
}

class TicketDetails extends StatelessWidget {
  const TicketDetails({super.key, required this.ticketModel});

  final BookingDetails ticketModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomerName(customerName: ticketModel.result!.customerName!),
        const Divider(),
        BorderedCard(
          child: BookingDetailsWidget(
            eventName: ticketModel.result!.eventTitle!,
            concertDate: ticketModel.result!.eventDate!,
            seatNumber: ticketModel.result!.seats!.length.toString(),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MultiSelectContainer(
              itemsDecoration: MultiSelectDecorations(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.green.withOpacity(0.1),
                      Colors.yellow.withOpacity(0.1),
                    ]),
                    border: Border.all(color: Colors.green[200]!),
                    borderRadius: BorderRadius.circular(15)),
                selectedDecoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.green, Colors.lightGreen]),
                    border: Border.all(color: Colors.green[700]!),
                    borderRadius: BorderRadius.circular(5)),
                disabledDecoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(5)),
              ),
              items: ticketModel.result!.seats!
                  .map((seat) => MultiSelectCard(
                      contentPadding: const EdgeInsets.all(20),
                      prefix: MultiSelectPrefix(
                        disabledPrefix: const Icon(Icons.disabled_by_default),
                        enabledPrefix: const Icon(Icons.chair),
                        selectedPrefix: const Icon(Icons.star),
                      ),
                      value: seat.seatNo,
                      label: seat.seatNo,
                      textStyles: const MultiSelectItemTextStyles(
                          disabledTextStyle: TextStyle(fontSize: 20),
                          selectedTextStyle: TextStyle(fontSize: 20),
                          textStyle:
                              TextStyle(fontSize: 20, color: Colors.black)),
                      enabled: !(seat.taken ?? false)))
                  .toList(),
              onChange: (allSelectedItems, selectedItem) {}),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {}, // TODO: submit selected tickets.
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text("Submit"),
          ),
        ),
      ],
    );
  }
}
