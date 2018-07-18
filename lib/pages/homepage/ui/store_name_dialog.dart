import 'package:flutter/material.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class StoreNameDialog extends StatelessWidget {
  final AccountModel account;
  final TextEditingController controller;

  StoreNameDialog({
    Key key,
    @required this.account,
  })  : controller = new TextEditingController(text: account.storeName),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 48.0),
              Center(
                child: CircleAvatar(
                  backgroundColor: kAccentColor,
                  foregroundColor: Colors.white,
                  child: Icon(
                    Icons.store,
                    size: 50.0,
                  ),
                  radius: 36.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text("Store Name", style: ralewayMedium(18.0, Colors.black38)),
              const SizedBox(height: 64.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
                child: Theme(
                  data: ThemeData(
                    hintColor: kBorderSideColor,
                    primaryColor: kPrimaryColor,
                  ),
                  child: new TextField(
                    keyboardType: TextInputType.text,
                    controller: controller,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    onSubmitted: (value) => _handleSubmit(context),
                    decoration: new InputDecoration(
                      isDense: true,
                      hintText: "Enter Store Name",
                      hintStyle: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    final _value = controller.text.trim();
    if (_value.isEmpty) {
      return;
    }
    Navigator.pop(context, _value);
  }
}
