import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/core/widgets/custom_app_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String redirectUrl;
  const PaymentWebView({super.key, required this.redirectUrl});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..clearLocalStorage()
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.google.com')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            _isLoading.value = true;
          },
          onPageFinished: (String url) {
            _isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Confirm Payment",
        onTap: () {
          context.pop();
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWebView,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 100.h - kToolbarHeight,
              child: getWebView(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshWebView() async {
    _isLoading.value = true;
    _webViewController.clearCache();
    _webViewController.reload();
  }

  Widget getWebView() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else {
            return WebViewWidget(
              controller: _webViewController,
            );
          }
        },
      ),
    );
  }
}
