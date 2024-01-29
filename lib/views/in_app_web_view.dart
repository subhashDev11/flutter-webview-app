// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:provider/provider.dart';
//
// class WebScreen extends StatefulWidget {
//   final String url;
//   final String? title;
//
//   const WebScreen({
//     super.key,
//     required this.url,
//     this.title,
//   });
//
//   static Widget newInstance({
//     required String url,
//     String? title,
//   }) {
//     return ChangeNotifierProvider<WebViewStateProvider>.value(
//       value: WebViewStateProvider(),
//       child: WebScreen(
//         url: url,
//         title: title,
//       ),
//     );
//   }
//
//   @override
//   State<WebScreen> createState() => _WebScreenState();
// }
//
// class _WebScreenState extends State<WebScreen> {
//   final InAppWebViewSettings _options = InAppWebViewSettings(
//     // useShouldOverrideUrlLoading: true,
//     // mediaPlaybackRequiresUserGesture: false,
//     javaScriptCanOpenWindowsAutomatically: true,
//     javaScriptEnabled: true,
//     // useOnDownloadStart: true,
//     // transparentBackground: true,
//     //allowFileAccessFromFileURLs: true,
//     // allowUniversalAccessFromFileURLs: true,
//     cacheEnabled: true,
//     supportZoom: false,
//     // useHybridComposition: true,
//     // allowFileAccess: true,
//     // allowContentAccess: true,
//     // databaseEnabled: true,
//     domStorageEnabled: true,
//     // allowsInlineMediaPlayback: true,
//     allowsBackForwardNavigationGestures: true,
//     allowsLinkPreview: true,
//     sharedCookiesEnabled: true,
//   );
//
//   InAppWebViewController? webViewController;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WebViewStateProvider>(
//       builder: (context, state, child) {
//         return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.white,
//             leading: IconButton(
//               icon: const Icon(
//                 Icons.arrow_back_ios_new_outlined,
//                 color: Colors.black,
//               ),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             title: Text(widget.title ?? ""),
//             centerTitle: true,
//           ),
//           body: state.loadingWebView
//               ? const Center(child: CircularProgressIndicator())
//               : _getWebBody(state),
//         );
//       },
//     );
//   }
//
//   Widget _getWebBody(WebViewStateProvider state) {
//     return Stack(
//       children: [
//         InAppWebView(
//           initialUrlRequest: URLRequest(
//             url: WebUri(widget.url),
//           ),
//           initialSettings: _options,
//           onWebViewCreated: (controller) async {
//             webViewController = controller;
//             context.read<WebViewStateProvider>().changeLoadingState(false);
//           },
//           onReceivedError: (ctr, uri, msg) {
//             log("Web load view $uri error - $msg");
//           },
//           onLoadStart: (controller, url) async {},
//           onLoadStop: (controller, url) async {},
//           onDownloadStartRequest: (controller, request) async {},
//           onLoadResourceWithCustomScheme: (controller, resource) {
//             log('loaded resource - ${resource.url}');
//             return Future(() => null);
//           },
//           onConsoleMessage: (_, message) {
//             log('console message - ${message.message}');
//           },
//         ),
//         Visibility(
//           visible: state.loadingWebView,
//           replacement: const SizedBox(),
//           child: const Center(child: CircularProgressIndicator()),
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     webViewController?.dispose();
//     super.dispose();
//   }
// }
//
// class WebViewStateProvider extends ChangeNotifier {
//   bool _loadingWebView = false;
//
//   bool get loadingWebView => _loadingWebView;
//
//   void changeLoadingState(bool value) {
//     _loadingWebView = value;
//     notifyListeners();
//   }
// }
