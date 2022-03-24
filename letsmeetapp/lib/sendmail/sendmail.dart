import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsmeet/ipconn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sendmail {
  Future sendmailer(
      {String name,
      String email,
      String subject,
      String body,
      String status,
      String reserve_id}) async {
    final response = await http.get(Uri.parse(
        "http://${ipconn}/letsmeet/email/sendEmail.php?name=${name}&email=${email}&subject=${subject}&body=${body}&status=${status}&reserve_id=${reserve_id}"));
  }
}
