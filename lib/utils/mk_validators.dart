import 'dart:io';

import 'package:flutter/widgets.dart';

typedef ValidatorFn<T, U> = U Function(T value);

class MkValidate {
  static ValidatorFn<String, String> tryAlpha([String error]) {
    return (String value) {
      if (value.isEmpty) {
        return error ?? 'Name is required.';
      }
      final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
      if (!nameExp.hasMatch(value)) {
        return error ?? 'Please enter only alphabetical characters.';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryDouble([String error]) {
    return (String value) {
      if (value == null || value.isEmpty) {
        return error ?? 'Field is required.';
      }
      if ((double.tryParse(value) ?? 0.0) <= 0.0) {
        return error ?? 'Not a valid number.';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryInt([String error]) {
    return (String value) {
      if (value == null || value.isEmpty) {
        return error ?? 'Field is required.';
      }
      if ((int.tryParse(value) ?? 0.0) <= 0) {
        return error ?? 'Not a valid number.';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryEmail([String error]) {
    return (String value) {
      if (value.isEmpty) {
        return error ?? 'Email is required.';
      }
      if (!value.contains('@')) {
        return error ?? 'Not a valid email.';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryPhone([String error]) {
    return (String value) {
      if (value.isEmpty) {
        return error ?? 'Phone number is required.';
      }
      if (!RegExp(r'^\d+?$').hasMatch(value) ||
          !value.startsWith(RegExp("0[1789]")) ||
          // Land lines eg 01
          (value.startsWith("01") && value.length != 9) ||
          // Land lines eg 080
          (value.startsWith(RegExp("0[789]")) && value.length != 11)) {
        return error ?? 'Not a valid phone number.';
      }
      return null;
    };
  }

  static ValidatorFn<List<dynamic>, String> tryList([String error]) {
    return (List<dynamic> value) {
      if (value == null || value.isEmpty) {
        return error ?? 'Field is required.';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryPassword([String error]) {
    return (String value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return error ?? 'Password field is required.';
      }
      if (!value.contains(RegExp(r'^.*(?=.{6,})(?=.*\d)(?=.*[a-zA-Z]).*$'))) {
        return 'Password field requires at least 6 characters with one digit & one alphabet.';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryString([String error]) {
    return (String value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return error ?? 'Field is required.';
      }
      return null;
    };
  }

  static ValidatorFn<File, String> tryFile([String error]) {
    return (File file) {
      if (file == null || file.path.isEmpty) {
        return error ?? 'Invalid File.';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryAmount([String error]) {
    return (String value) {
      if (value.isEmpty) {
        return error ?? 'Amount is required.';
      }
      if (double.tryParse(value) == null) {
        return error ?? 'Invalid Amount.';
      }
      if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
        return error ?? 'Not a valid amount.';
      }
      if (double.tryParse(value) <= 0.0) {
        return error ?? 'Zero Amount is not allowed.';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryDiff(
    FormFieldState<String> field, [
    String error,
  ]) {
    return (String value) {
      if (field?.value != value) {
        return error ?? 'Values don\'t match';
      }
      return null;
    };
  }

  static ValidatorFn<String, String> tryDiffPassword(
    FormFieldState<String> passwordField,
  ) {
    return (String value) {
      if (passwordField == null) {
        return 'Please enter a password.';
      }
      if (passwordField.value == null || passwordField.value.isEmpty) {
        return 'Please enter a password.';
      }
      return tryDiff(
        passwordField,
        'The passwords don\'t match',
      )(value);
    };
  }
}
