// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:flutter_html/flutter_html.dart';

// class MyEditor extends StatefulWidget {
//   @override
//   _MyEditorState createState() => _MyEditorState();
// }

// class _MyEditorState extends State<MyEditor> {
//   final _controller = quill.QuillController.basic();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               quill.QuillToolbar.basic(
//                 controller: _controller,
//                 toolbarIconSize: 30,
//                 iconTheme: const quill.QuillIconTheme(),
//               ),
//               quill.QuillEditor.basic(
//                 controller: _controller,
//                 readOnly: false,
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
//                   String plainText = _controller.document.toPlainText();
//                   String? html = convertPlainTextToHtml(plainText);
//                   print(html);
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String? convertPlainTextToHtml(String plainText) {
//     return Html(
//       data: plainText,
//       style: {
//         'body': Style(
//           margin: EdgeInsets.zero,
//           padding: EdgeInsets.zero,
//         ),
//       },
//     ).data;
//   }
// }

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

void main() {
  runApp(MyEditor());
}

class MyEditor extends StatefulWidget {
  @override
  _MyEditorState createState() => _MyEditorState();
}

class _MyEditorState extends State<MyEditor> {
  late HtmlEditorController controller;
  String? textToDisplay;
  @override
  void initState() {
    super.initState();
    controller = HtmlEditorController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTML Editor Demo'),
        ),
        body: StatefulBuilder(builder: (context, setState) {
          return Column(
            children: [
              SizedBox(
                height: 300,
                child: HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: 'Your text here...',
                    // shouldEnsureVisible: true,
                    // autoAdjustHeight: true,
                    //initialText: "<p>text content initial, if any</p>",
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    // toolbarPosition: ToolbarPosition.aboveEditor,
                    toolbarType: ToolbarType.nativeScrollable,
                    defaultToolbarButtons: [
                      StyleButtons(
                        style: false,
                      ),
                      FontSettingButtons(
                        fontName: false,
                        fontSizeUnit: false,
                      ),
                      FontButtons(
                        clearAll: false,
                        strikethrough: false,
                        subscript: false,
                        superscript: false,
                      ),
                      ColorButtons(
                        foregroundColor: false,
                        highlightColor: false,
                      ),
                      ListButtons(
                        ul: false,
                        ol: false,
                        listStyles: false,
                      ),
                      ParagraphButtons(
                        increaseIndent: false,
                        decreaseIndent: false,
                        textDirection: false,
                        lineHeight: false,
                        caseConverter: false,
                      ),
                      InsertButtons(
                        link: false,
                        picture: false,
                        audio: false,
                        video: false,
                        table: false,
                        hr: false,
                      ),
                      OtherButtons(
                        fullscreen: false,
                        codeview: false,
                        help: false,
                      ),
                    ],
                    customToolbarButtons: [
                      //your widgets here
                      // Button1(),
                      // Button2(),
                    ],
                    customToolbarInsertionIndices: [2, 5],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // final htmlContent = controller.getText();
                  String? txt = await controller.getText();
                  setState(() {
                    textToDisplay = txt;
                  });
                  // print(htmlContent);
                  print(textToDisplay); // print the controller instance
                },
                child: Text('Get HTML'),
              ),
              if (textToDisplay != null) Text(textToDisplay!)
            ],
          );
        }),
      ),
    );
  }
}
