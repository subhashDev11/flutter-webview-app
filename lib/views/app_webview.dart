import 'package:flutter/material.dart';
import 'package:bednbreads/views/loading_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebStateProvider extends ChangeNotifier {
  /// Initially True. Will become false once the first page of Webview is ready.
  bool isWebViewLoading = false;

  /// Initially True. True every time any page is loading.
  bool isPageLoading = false;

  /// True when error occurs. False otherwise
  bool errorOccurred = false;

  void setIsWebViewLoading(bool value) {
    isWebViewLoading = value;
    notifyListeners();
  }

  void setIsPageLoading(bool value) {
    isPageLoading = value;
    notifyListeners();
  }

  void setErrorOccurred(bool value) {
    errorOccurred = value;
    notifyListeners();
  }
}

/// The main app screen displaying the Web app screens as a Webview.
class WebViewAppPage extends StatefulWidget {
  const WebViewAppPage({Key? key, required String webviewURL})
      : webviewURL = webviewURL,
        super(key: key);

  final String webviewURL;

  @override
  _WebViewAppPageState createState() => _WebViewAppPageState();
}

class _WebViewAppPageState extends State<WebViewAppPage> {
  /// Manages WebView
  WebViewController? webViewController;

  /// Initially True. Will become false once the first page of Webview is ready.
  late bool isWebViewLoading;

  /// Initially True. True every time any page is loading.
  late bool isPageLoading;

  /// True when error occurs. False otherwise
  late bool errorOccured;

  /// Handles OneSignal functionality
  //late NotificationHandler notificationHandler;

  @override
  void initState() {
    // // OneSignal Service Setup
    // if (Platform.isAndroid || Platform.isIOS) {
    //   notificationHandler = NotificationHandler(appID: 'ONESIGNAL_APP_ID');
    //   if (!Platform.isAndroid)
    //     notificationHandler.getPermission().then(
    //       (bool wasPermissionGiven) {
    //         if (!wasPermissionGiven)
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(
    //               content: const Text('Notification permission not given!'),
    //             ),
    //           );
    //       },
    //     );
    //   notificationHandler.establishCallbacks(context);
    // }

    isWebViewLoading = true;
    isPageLoading = true;
    errorOccured = false;
    // WebView initial states.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {
              setState(
                () {
                  isPageLoading = true;
                  errorOccured = false;
                },
              );
            },
            onPageFinished: (String url) {
              setState(
                () {
                  isWebViewLoading = false;
                  isPageLoading = false;
                },
              );
            },
            onWebResourceError: (WebResourceError error) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(
              //       'Failed to load URL: ${error.url}',
              //       style: const TextStyle(fontWeight: FontWeight.w600),
              //     ),
              //     backgroundColor: Colors.red,
              //   ),
              // );
              setState(
                () {
                  isWebViewLoading = false;
                  isPageLoading = false;
                  errorOccured = true;
                },
              );
            },
            // onNavigationRequest: (NavigationRequest request) {
            //   if (request.url.startsWith(widget.webviewURL)) {
            //     return NavigationDecision.prevent;
            //   }
            //   return NavigationDecision.navigate;
            // },
          ),
        )
        ..loadRequest(
          Uri.parse(widget.webviewURL),
        );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color stackItemsColor = Colors.red;
    print(errorOccured);
    return WillPopScope(
      onWillPop: () async {
        if (webViewController != null &&
            (await webViewController?.canGoBack() ?? false)) {
          webViewController!.goBack();
          return Future.microtask(() => false);
        } else {
          return _showBackDialog();;
        }
      },
      child: Scaffold(
        backgroundColor: stackItemsColor,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 44,
              ),
              child: webViewController != null
                  ? WebViewWidget(
                      controller: webViewController!,
                    )
                  : SizedBox(),
            ),
            if (isPageLoading)
              const Center(
                child: CircularProgressIndicator(color: stackItemsColor),
              ),
            if (errorOccured && webViewController != null)
              PageButtons(
                buttonColor: stackItemsColor,
                webViewController: webViewController!,
              ),
            if (isWebViewLoading)
              const LoadingScreen(
                loadingScreenBackgroundColor: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showBackDialog() async {
    bool? pop = false;
    pop = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to exit BedNBreads?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.red,
                ),
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.red,
                ),
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return pop ?? false;
  }
}

/*

/// Manages WebView
  WebViewController? webViewController;

  /// Initially True. Will become false once the first page of Webview is ready.
  late bool isWebViewLoading;

  /// Initially True. True every time any page is loading.
  late bool isPageLoading;

  /// True when error occurs. False otherwise
  late bool errorOccured;

  /// Handles OneSignal functionality
  //late NotificationHandler notificationHandler;

  @override
  void initState() {
    // // OneSignal Service Setup
    // if (Platform.isAndroid || Platform.isIOS) {
    //   notificationHandler = NotificationHandler(appID: 'ONESIGNAL_APP_ID');
    //   if (!Platform.isAndroid)
    //     notificationHandler.getPermission().then(
    //       (bool wasPermissionGiven) {
    //         if (!wasPermissionGiven)
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(
    //               content: const Text('Notification permission not given!'),
    //             ),
    //           );
    //       },
    //     );
    //   notificationHandler.establishCallbacks(context);
    // }

    isWebViewLoading = true;
    isPageLoading = true;
    errorOccured = false;
    // WebView initial states.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {
              setState(
                    () {
                  isPageLoading = true;
                  errorOccured = false;
                },
              );
            },
            onPageFinished: (String url) {
              setState(
                    () {
                  isWebViewLoading = false;
                  isPageLoading = false;
                },
              );
            },
            onWebResourceError: (WebResourceError error) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(
              //       'Failed to load URL: ${error.url}',
              //       style: const TextStyle(fontWeight: FontWeight.w600),
              //     ),
              //     backgroundColor: Colors.red,
              //   ),
              // );
              setState(
                    () {
                  isWebViewLoading = false;
                  isPageLoading = false;
                  errorOccured = true;
                },
              );
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith(widget.webviewURL)) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(
          Uri.parse(widget.webviewURL),
        );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color stackItemsColor = Colors.red;
    print(errorOccured);
    return Scaffold(
      backgroundColor: stackItemsColor,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 44,
            ),
            child: webViewController!=null ? WebViewWidget(
              controller: webViewController!,
            ) : SizedBox(),
          ),
          if (isPageLoading)
            const Center(
              child: CircularProgressIndicator(color: stackItemsColor),
            ),
          if (errorOccured && webViewController!=null)
            PageButtons(
              buttonColor: stackItemsColor,
              webViewController: webViewController!,
            ),
          if (isWebViewLoading)
            const LoadingScreen(
                loadingScreenBackgroundColor: Colors.white,
            ),
        ],
      ),
    );
  }
 */

/// Page Buttons that show up only when there is an Error in loading Webview.
///
/// When there is no error, the Web App itself can be used for navigation
/// so these are not needed. Pass in the [webViewController] and [buttonColor].
class PageButtons extends StatelessWidget {
  const PageButtons({
    Key? key,
    required this.buttonColor,
    required this.webViewController,
  }) : super(key: key);

  final Color buttonColor;
  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      child: Column(
        children: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
            ),
            onPressed: () => webViewController.reload(),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            onPressed: () => webViewController.goBack(),
          ),
        ],
      ),
    );
  }
}
