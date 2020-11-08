import 'package:flutter/material.dart';
import 'package:zbot_app/constants.dart';

class TextFormFieldWithEditControl extends StatefulWidget {
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String fieldKey;
  final Function validator;
  final TextInputType keyboardType;
  final bool readOnly;

  const TextFormFieldWithEditControl({
    this.textCapitalization = TextCapitalization.none,
    this.controller, this.labelText,
    this.fieldKey,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.readOnly = false,
  });

  @override
  State<StatefulWidget> createState() => _TextFormFieldWithEditControlState();
}

class _TextFormFieldWithEditControlState extends State<TextFormFieldWithEditControl> {
  bool _readOnly = true;

  @override
  void initState() {
    //makes field editable, else have to click edit icon
    super.initState();
    if (widget.controller.text.isEmpty){
      _readOnly = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      controller: widget.controller,
      readOnly: widget.readOnly ? widget.readOnly : _readOnly,
      decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          suffixIcon :  IconButton(
            onPressed: () => (setState((){_readOnly = !_readOnly;})),
            icon: Icon((widget.readOnly == true || _readOnly) ? Icons.lock_outline : Icons.edit, color: uiSecondaryColor),
          )
      ),
      key: ValueKey(widget.fieldKey),
      validator: widget.validator,
    );
  }
}

class TextFormFieldStyled extends StatelessWidget {
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final String labelText;
  final String initialValue;
  final String hintText;
  final String fieldKey;
  final Function validator;
  final Function onChanged;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool autoValidate;

  TextFormFieldStyled({this.initialValue, this.textCapitalization = TextCapitalization.none, @required this.controller, this.labelText, this.hintText,
    this.fieldKey, this.validator, this.onChanged, this.keyboardType, this.readOnly = false, this.autoValidate = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      key: ValueKey(fieldKey),
      validator: validator,
      onChanged: onChanged,
      autovalidate: autoValidate,
    );
  }
}
