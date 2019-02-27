///
/// Copyright (C) 2019 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  21 Feb 2019
///
///

import 'package:flutter/material.dart';

import 'package:mvc_application/mvc.dart' show StateMVC;

import 'package:weathercast/src/controller.dart' show LocationCon;

import 'package:weathercast/src/home/view/drawer/weather_locations/mvc.dart' show LocationCon;

List<DemoItem<dynamic>> weatherLocations(
    {StateMVC state, FormFieldSetter<String> onSaved}) {
  List<DemoItem<dynamic>> _demoItems = <DemoItem<dynamic>>[
    DemoItem<String>(
        name: 'Location',
        value: LocationCon.value,
        hint: 'Select location',
        valueToString: (String location) => location,
        builder: (DemoItem<String> item) {
          void close() {
            state.setState(() {
              item.isExpanded = false;
            });
          }

          return Form(child: Builder(builder: (BuildContext context) {
            return CollapsibleBody(
              onSave: () {
                Form.of(context).save();
                close();
              },
              onCancel: () {
                Form.of(context).reset();
                close();
              },
              child: FormField<String>(
                  initialValue: item.value,
                  onSaved: (String result) {
                    item.value = result;
                    if (onSaved != null) onSaved(result);
                  },
                  builder: (FormFieldState<String> field) {
                    return Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: LocationCon.locations?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return LocationCon.option(index, field);
                              })),
                    ]);
                  }),
            );
          }));
        })
  ];

  return _demoItems;
}

typedef DemoItemBodyBuilder<T> = Widget Function(DemoItem<T> item);
typedef ValueToString<T> = String Function(T value);

class DemoItem<T> {
  DemoItem({this.name, this.value, this.hint, this.builder, this.valueToString})
      : textController = TextEditingController(text: valueToString(value));

  final String name;
  final String hint;
  final TextEditingController textController;
  final DemoItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  T value;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return DualHeaderWithHint(
          name: name,
          value: valueToString(value),
          hint: hint,
          showHint: isExpanded);
    };
  }

  Widget build() => builder(this);
}

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({this.name, this.value, this.hint, this.showHint});

  final String name;
  final String value;
  final String hint;
  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Row(children: <Widget>[
      Expanded(
        flex: 2,
        child: Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: textTheme.body1.copyWith(fontSize: 15.0),
            ),
          ),
        ),
      ),
      Expanded(
          flex: 3,
          child: Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: _crossFade(
                  Text(value,
                      style: textTheme.caption.copyWith(fontSize: 15.0)),
                  Text(hint, style: textTheme.caption.copyWith(fontSize: 15.0)),
                  showHint)))
    ]);
  }
}

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody(
      {this.margin = EdgeInsets.zero, this.child, this.onSave, this.onCancel});

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Column(children: <Widget>[
      Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0) -
              margin,
          child: Center(
              child: DefaultTextStyle(
                  style: textTheme.caption.copyWith(fontSize: 15.0),
                  child: child))),
      const Divider(height: 1.0),
      Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
                    onPressed: onCancel,
                    child: const Text('CANCEL',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500)))),
            Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: FlatButton(
                    onPressed: onSave,
                    textTheme: ButtonTextTheme.accent,
                    child: const Text('SAVE')))
          ]))
    ]);
  }
}
