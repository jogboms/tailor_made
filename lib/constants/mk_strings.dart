import 'dart:async' show TimeoutException;

import 'package:tailor_made/firebase/settings.dart';
import 'package:tailor_made/utils/mk_response_wrapper.dart';

class MkStrings {
  MkStrings._();

  static const String appName = "TailorMade";
  static const String networkError =
      "Please check your network connection or contact your service provider if the problem persists.";
  static const String errorMessage = "An error occurred. Please try again.";
  static const String fixErrors =
      "Please fix the errors in red before submitting";
  static const String leavingEmptyMeasures =
      "Leaving Measurements empty? Click on Scissors button.";
  static const List<String> monthsShort = <String>[
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec",
  ];
  static const List<String> monthsFull = <String>[
    "January",
    "Febuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static String genericError(dynamic error) {
    if (error is TimeoutException) {
      return "This action took too long. Please Retry.";
    }
    return Settings.isDev || error is MkResponseException
        ? "$error"
        : errorMessage;
  }
}
