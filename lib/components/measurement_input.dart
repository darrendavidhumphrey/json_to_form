import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MeasurementInput extends StatefulWidget {
  MeasurementInput({
    Key? key,
    required this.item,
    required this.onChange,
    required this.position,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
  }) : super(key: key);
  final dynamic item;
  final Function onChange;
  final int position;
  final Map errorMessages;
  final Map validations;
  final Map decorations;

  @override
  _MeasurementInput createState() => new _MeasurementInput();
}

class _MeasurementInput extends State<MeasurementInput> {
  dynamic item;

  final List<String> unitsItems = [
    'mm',
    'cm',
    'm',
    'in',
    'ft'
  ];


  String? isRequired(item, value) {
    if (value.isEmpty) {
      return widget.errorMessages[item['key']] ?? 'Please a valid measurement';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  Widget dropdownWidget({String initialValue="mm"}) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: initialValue,
        isExpanded: false,
        hint: Text(
          'Units',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: unitsItems.map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ))
            .toList(),
        onChanged: (String? value) {
          if (value != null) {
            print("Units changed to $value");
            //TODO: invoke onchanged.
            //widget.onChange(widget.position, value);
          }
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Widget label = SizedBox.shrink();

    return new Container(
      margin: new EdgeInsets.only(top: 5.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          label,
          new TextFormField(
            controller: null,
            initialValue: item['value'] ?? null,
            decoration: item['decoration'] ??
                widget.decorations[item['key']] ??
                new InputDecoration(
                  hintText: item['placeholder'] ?? "",
                  helperText: item['helpText'] ?? "",
                ),
            maxLines: 1,
            onChanged: (String value) {
              item['value'] = value;
              widget.onChange(widget.position, value);
            },
            keyboardType: TextInputType.number,
            validator: (value) {
              if (widget.validations.containsKey(item['key'])) {
                return widget.validations[item['key']](item, value);
              }
              if (item.containsKey('validator')) {
                if (item['validator'] != null) {
                  if (item['validator'] is Function) {
                    return item['validator'](item, value);
                  }
                }
              }

              if (item.containsKey('required')) {
                if (item['required'] == true ||
                    item['required'] == 'True' ||
                    item['required'] == 'true') {
                  return isRequired(item, value);
                }
              }
              return null;
            },
          ),

        ],
      ),
    );
  }
}
