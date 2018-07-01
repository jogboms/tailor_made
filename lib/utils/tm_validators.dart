validateAlpha() {
  return (String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) return 'Please enter only alphabetical characters.';
    return null;
  };
}

validateAmount() {
  return (String value) {
    if (value.isEmpty) return 'Amount is required.';
    if (double.tryParse(value) == null) return 'Invalid Amount.';
    if (!(new RegExp(r'^\d+(\.\d{1,2})?$')).hasMatch(value)) return 'Not a valid amount.';
    if (double.tryParse(value).ceil() <= 0) return 'Zero Amount is not allowed.';
    return null;
  };
}
