import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';


class WebViewXPage extends StatefulWidget {
  const WebViewXPage ({Key? key, required this.html}) : super(key: key);
  final String html;
  @override
  State<WebViewXPage> createState() => _WebViewXPageState();
}

class _WebViewXPageState extends State<WebViewXPage> {
  late WebViewXController webviewController;
  Size get screenSize => MediaQuery.of(context).size;

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
          ),
          child: WebViewX(
            key: const ValueKey('webviewx'),
            initialContent: widget.html,
            initialSourceType: SourceType.html,
            height: screenSize.height / 2,
            width: 300,
            onWebViewCreated: (controller) => webviewController = controller,
            onPageStarted: (src) =>
                debugPrint('A new page has started loading: $src\n'),
            onPageFinished: (src) =>
                debugPrint('The page has finished loading: $src\n'),
            jsContent: const {
              EmbeddedJsContent(
                js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
              ),
              EmbeddedJsContent(
                webJs:
                    "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
                mobileJs:
                    "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
              ),
            },
            webSpecificParams: const WebSpecificParams(
              printDebugInfo: true,
            ),
            mobileSpecificParams: const MobileSpecificParams(
              androidEnableHybridComposition: true,
            ),
            navigationDelegate: (navigation) {
              debugPrint(navigation.content.sourceType.toString());
              return NavigationDecision.navigate;
            },
          ),
        )
      ),
    );
  }
}