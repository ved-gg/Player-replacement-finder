import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class TableauPlot extends StatefulWidget {
  const TableauPlot({super.key});

  @override
  State<TableauPlot> createState() => _TableauPlotState();
}

class _TableauPlotState extends State<TableauPlot> {
  late WebViewXController webviewController;

  final String tableauHTML = '''
  <html>
    <head>
      <script type="text/javascript" src="https://public.tableau.com/javascripts/api/tableau-2.min.js"></script>
      <style>
        html, body { margin: 0; padding: 0; height: 100vh; width: 100vw; }
        #tableauViz { width: 100%; height: 100vh; }
      </style>
    </head>
    <body>
      <div id="tableauViz" style="width: 100%; height: 100%;"></div>
      <script type="text/javascript">
        var viz;
        function initViz() {
          var containerDiv = document.getElementById("tableauViz");
          var url = "https://public.tableau.com/views/FootballAnalytics_17416302557820/Sheet1";
          var options = {
            hideTabs: true,
            width: "100%",
            height: "100vh"
          };
          viz = new tableau.Viz(containerDiv, url, options);
        }
        window.onload = initViz;
      </script>
    </body>
  </html>
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tableau Dashboard")),
      body: WebViewX(
        initialContent: tableauHTML,
        initialSourceType: SourceType.HTML,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2,
        onWebViewCreated: (controller) {
          webviewController = controller;
        },
      ),
    );
  }
}
