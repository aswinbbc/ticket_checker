import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:ticket_checker/constants/colors.dart';
import 'package:ticket_checker/features/checker/model/booking_details_model.dart';
import 'package:ticket_checker/features/checker/repo/checker_repo.dart';
import 'package:ticket_checker/features/checker/widget/bookedname.dart';
import 'package:ticket_checker/features/checker/widget/bookingdetails.dart';
import 'package:ticket_checker/features/checker/widget/bordercard.dart';
import 'package:ticket_checker/utils/app_build_methods.dart';
import 'package:ticket_checker/utils/extensions.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.data,
    required this.seatNos,
  });
  final String seatNos;
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
        seatNos: seatNos,
      ),
    );
  }
}

class TicketDetails extends StatelessWidget {
  TicketDetails({super.key, required this.ticketModel, required this.seatNos});

  final BookingDetails ticketModel;
  final String seatNos;
  List<String?> selected = [];
  @override
  Widget build(BuildContext context) {
    var selectedBoxDecoration = BoxDecoration(
        gradient:
            const LinearGradient(colors: [Colors.green, Colors.lightGreen]),
        border: Border.all(color: Colors.green[700]!),
        borderRadius: BorderRadius.circular(5));
    var disabledBoxDecoration = BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.grey[500]!),
        borderRadius: BorderRadius.circular(5));
    var boxDecoration = BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.green.withOpacity(0.1),
          Colors.yellow.withOpacity(0.1),
        ]),
        border: Border.all(color: Colors.green[200]!),
        borderRadius: BorderRadius.circular(15));
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
                decoration: boxDecoration,
                selectedDecoration: selectedBoxDecoration,
                disabledDecoration: disabledBoxDecoration,
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
              onChange: (allSelectedItems, selectedItem) {
                selected = allSelectedItems;
              }),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (selected.isNotEmpty) {
                submitDetails(
                  context,
                  seatNo: selected.join(',').log(),
                  ticketNo: ticketModel.result?.orderNo ?? '',
                  totalSeats: seatNos,
                );
              }
            }, // TODO: submit selected tickets.
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

  void submitDetails(BuildContext context,
      {required String seatNo,
      required String ticketNo,
      required String totalSeats}) {
    SubmitTicketRepo(seatNo: seatNo, ticketNo: ticketNo, totalSeats: totalSeats)
        .fetchFromAPIService(onShowError: (msg, [asToast]) {
      showAppToast(msg: msg);
    }, onSuccess: (message) {
      showAppToast(msg: message ?? '');
      Navigator.pop(context);
    });
  }
}
