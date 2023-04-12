import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:selectable_container/selectable_container.dart';
import 'package:ticket_checker/constants/colors.dart';
import 'package:ticket_checker/dummy_data.dart';
import 'package:ticket_checker/features/checker/model/booking_details_model.dart';
import 'package:ticket_checker/features/checker/widget/bookedname.dart';
import 'package:ticket_checker/features/checker/widget/bookingdetails.dart';
import 'package:ticket_checker/features/checker/widget/bordercard.dart';
import 'package:ticket_checker/features/checker/widget/qr_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var orderNumberController = TextEditingController();
  BookingDetails data = BookingDetails.fromJson(ticketJson);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Center(child: Text("Booked Tickets")),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QrScannerBox(orderNumberController: orderNumberController),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Search"),
            ),
          ),

          ///TODO:fetch data from api
          ///show only if data is available
          if (data != null)
            TicketDetails(
              ticketModel: data,
            ),
        ],
      ),
    );
  }
}

class TicketDetails extends StatelessWidget {
  const TicketDetails({super.key, required this.ticketModel});

  final BookingDetails ticketModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
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
                        value: seat.seatNo,
                        label: seat.seatNo,
                        enabled: !(seat.taken ?? false)))
                    .toList(),
                onChange: (allSelectedItems, selectedItem) {}),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
