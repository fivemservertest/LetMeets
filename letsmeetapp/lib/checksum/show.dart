// To parse this JSON data, do
//
//     final show = showFromJson(jsonString);

import 'dart:convert';

List<Show> showFromJson(String str) => List<Show>.from(json.decode(str).map((x) => Show.fromJson(x)));

String showToJson(List<Show> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Show {
    Show({
        this.reserveId,
        this.roomId,
        this.userId,
        this.dateTime,
        this.datein,
        this.dateout,
        this.status,
        this.teamId,
        this.name,
        this.detail,
        this.size,
        this.price,
        this.image,
    });

    String reserveId;
    String roomId;
    String userId;
    DateTime dateTime;
    DateTime datein;
    DateTime dateout;
    String status;
    String teamId;
    String name;
    String detail;
    String size;
    String price;
    String image;

    factory Show.fromJson(Map<String, dynamic> json) => Show(
        reserveId: json["reserve_id"] == null ? null : json["reserve_id"],
        roomId: json["room_id"] == null ? null : json["room_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        datein: json["datein"] == null ? null : DateTime.parse(json["datein"]),
        dateout: json["dateout"] == null ? null : DateTime.parse(json["dateout"]),
        status: json["status"] == null ? null : json["status"],
        teamId: json["team_id"] == null ? null : json["team_id"],
        name: json["name"] == null ? null : json["name"],
        detail: json["detail"] == null ? null : json["detail"],
        size: json["size"] == null ? null : json["size"],
        price: json["price"] == null ? null : json["price"],
        image: json["image"] == null ? null : json["image"],
    );

    Map<String, dynamic> toJson() => {
        "reserve_id": reserveId == null ? null : reserveId,
        "room_id": roomId == null ? null : roomId,
        "user_id": userId == null ? null : userId,
        "dateTime": dateTime == null ? null : dateTime.toIso8601String(),
        "datein": datein == null ? null : datein.toIso8601String(),
        "dateout": dateout == null ? null : dateout.toIso8601String(),
        "status": status == null ? null : status,
        "team_id": teamId == null ? null : teamId,
        "name": name == null ? null : name,
        "detail": detail == null ? null : detail,
        "size": size == null ? null : size,
        "price": price == null ? null : price,
        "image": image == null ? null : image,
    };
}
