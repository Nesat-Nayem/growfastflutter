import 'package:flutter/material.dart';
import 'package:grow_first/core/theme/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';

class VendorWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const VendorWebViewPage({
    super.key,
    required this.url,
    this.title = 'Become a Vendor',
  });

  @override
  State<VendorWebViewPage> createState() => _VendorWebViewPageState();
}

class _VendorWebViewPageState extends State<VendorWebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;
  String currentUrl = '';

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              currentUrl = url;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              currentUrl = url;
            });
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading page: ${error.description}'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.3),
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(12.0), // AppBar spacing fix
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => context.pop(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: textBlackColor, width: 0.7),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 88, 84, 84),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black87),
        //   onPressed: () => context.pop(),
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (currentUrl.isNotEmpty)
              Text(
                Uri.parse(currentUrl).host,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
          ],
        ),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
              controller.reload();
            },
          ),
          // Share/Open in browser button
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: Colors.black87),
            onPressed: () async {
              // You can implement url_launcher here if needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Open in external browser feature can be added',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),

          // Loading indicator
          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF6366F1), // violetBlueColor
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      // Modern bottom navigation bar with web controls
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Back button
            _buildNavButton(
              icon: Icons.arrow_back_ios,
              onPressed: () async {
                if (await controller.canGoBack()) {
                  controller.goBack();
                } else {
                  context.pop();
                }
              },
            ),

            // Forward button
            _buildNavButton(
              icon: Icons.arrow_forward_ios,
              onPressed: () async {
                if (await controller.canGoForward()) {
                  controller.goForward();
                }
              },
            ),

            // Home/Reset button
            _buildNavButton(
              icon: Icons.home,
              onPressed: () {
                controller.loadRequest(Uri.parse(widget.url));
              },
            ),

            // Close button
            _buildNavButton(
              icon: Icons.close,
              onPressed: () => context.pop(),
              color: Colors.red.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: color ?? Colors.black87, size: 20),
        onPressed: onPressed,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
