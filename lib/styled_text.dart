library styled_text;

import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final List<StyleText> customStyleList;
  final Color highlightColor;
  final bool onlyCustomsStyle;
  final FontWeight boldFontWeight;

  StyledText(
    this.text, {
    Key key,
    this.textStyle,
    this.customStyleList,
    this.highlightColor = Colors.blue,
    this.onlyCustomsStyle = false,
    this.boldFontWeight = FontWeight.bold,
  }) : super(key: key) {
    if (!onlyCustomsStyle)
      _styleTextList.addAll([
        StyleText(mask: "_C", style: TextStyle(color: highlightColor)),
        StyleText(mask: "_B", style: TextStyle(fontWeight: boldFontWeight)),
        StyleText(mask: "_I", style: TextStyle(fontStyle: FontStyle.italic)),
      ]);
    if (customStyleList != null) _styleTextList.addAll(customStyleList);
  }

  final List<StyleText> _styleTextList = List();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: textStyle,
        children: _spanList,
      ),
    );
  }

  List<TextSpan> get _spanList {
    final styleTextList = _styleTextList.reversed.toList();
    final spanList = List<TextSpan>();
    final regExp = RegExp(
        styleTextList.map((e) => "${e.mask}([\\s\\S]+?)${e.mask}").join("|"));
    final matches = regExp.allMatches(text);
    var start = 0;
    for (var match in matches) {
      spanList.add(TextSpan(text: text.substring(start, match.start)));
      match
          .groups(List.generate(match.groupCount, (index) => index + 1))
          .asMap()
          .forEach((index, groupText) {
        if (groupText != null) {
          spanList.add(
              TextSpan(text: groupText, style: styleTextList[index].style));
        }
      });
      start = match.end;
    }
    spanList.add(TextSpan(text: text.substring(start, text.length)));
    return spanList;
  }
}

class StyleText {
  final String mask;
  final TextStyle style;

  StyleText({@required this.mask, @required this.style});
}
