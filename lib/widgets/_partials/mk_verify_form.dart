import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkVerifyForm extends StatefulWidget {
  const MkVerifyForm({
    Key key,
    @required this.onDone,
  }) : super(key: key);

  final FormFieldSetter<String> onDone;

  @override
  _MkVerifyFormState createState() => _MkVerifyFormState();
}

class _MkVerifyFormState extends State<MkVerifyForm> {
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void dispose() {
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _style = MkTheme.of(context).display2Semi;
    return Row(
      children: <Widget>[
        SizedBox(width: 24.0),
        Expanded(
          child: TextField(
            focusNode: _focusNodes[0],
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).requestFocus(_focusNodes[1]);
              }
            },
            autofocus: true,
            decoration: InputDecoration(counterText: ""),
            style: _style,
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 24.0),
        Expanded(
          child: TextField(
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).requestFocus(_focusNodes[2]);
              } else if (value.isEmpty) {
                FocusScope.of(context).requestFocus(_focusNodes[0]);
              }
            },
            focusNode: _focusNodes[1],
            decoration: InputDecoration(counterText: ""),
            style: _style,
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 24.0),
        Expanded(
          child: TextField(
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).requestFocus(_focusNodes[3]);
              } else if (value.isEmpty) {
                FocusScope.of(context).requestFocus(_focusNodes[1]);
              }
            },
            focusNode: _focusNodes[2],
            decoration: InputDecoration(counterText: ""),
            style: _style,
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 24.0),
        Expanded(
          child: TextField(
            onChanged: (value) {
              if (value.length == 1) {
                widget.onDone(value);
              } else if (value.isEmpty) {
                FocusScope.of(context).requestFocus(_focusNodes[2]);
              }
            },
            focusNode: _focusNodes[3],
            decoration: InputDecoration(counterText: ""),
            style: _style,
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 24.0),
      ],
    );
  }
}
