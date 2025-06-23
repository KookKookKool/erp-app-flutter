import 'package:flutter/material.dart';

class StatusUtils {
  static Color getStatusColor(String status) {
    switch (status) {
      case "Done":
        return Colors.green;
      case "Processing":
        return Colors.orange;
      case "Canceled":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
