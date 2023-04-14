class BookingDetails {
  int? statusCode;
  String? message;
  bool? success;
  Result? result;

  BookingDetails({this.statusCode, this.message, this.success, this.result});

  BookingDetails.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    success = json['success'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['success'] = success;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  int? id;
  String? orderNo;
  String? eventTitle;
  String? netPrice;
  String? customerName;
  String? mobileNo;
  String? eventDate;
  String? seatType;
  String? bookedSeatNos;
  String? takenSeatNos;
  bool? isCompleted;
  String? createdAt;
  String? updatedAt;
  List<Seats>? seats;

  Result(
      {this.id,
      this.orderNo,
      this.eventTitle,
      this.netPrice,
      this.customerName,
      this.mobileNo,
      this.eventDate,
      this.seatType,
      this.bookedSeatNos,
      this.takenSeatNos,
      this.isCompleted,
      this.createdAt,
      this.updatedAt,
      this.seats});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    eventTitle = json['event_title'];
    netPrice = json['net_price'];
    customerName = json['customer_name'];
    mobileNo = json['mobile_no'];
    eventDate = json['event_date'];
    seatType = json['seat_type'];
    bookedSeatNos = json['booked_seat_nos'].toString();
    takenSeatNos = json['taken_seat_nos'].toString();
    isCompleted = json['is_completed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['seats'] != null) {
      seats = <Seats>[];
      json['seats'].forEach((v) {
        seats!.add(Seats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_no'] = orderNo;
    data['event_title'] = eventTitle;
    data['net_price'] = netPrice;
    data['customer_name'] = customerName;
    data['mobile_no'] = mobileNo;
    data['event_date'] = eventDate;
    data['seat_type'] = seatType;
    data['booked_seat_nos'] = bookedSeatNos;
    data['taken_seat_nos'] = takenSeatNos;
    data['is_completed'] = isCompleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (seats != null) {
      data['seats'] = seats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seats {
  String? seatNo;
  bool? taken;

  Seats({this.seatNo, this.taken});

  Seats.fromJson(Map<String, dynamic> json) {
    seatNo = json['seat_no'];
    taken = json['taken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seat_no'] = seatNo;
    data['taken'] = taken;
    return data;
  }
}
