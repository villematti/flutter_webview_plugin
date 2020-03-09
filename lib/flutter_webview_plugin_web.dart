import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

const _kChannel = 'flutter_webview_plugin';

class FlutterWebViewPluginWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        _kChannel, const StandardMethodCodec(), registrar.messenger);
    final FlutterWebViewPluginWeb instance = FlutterWebViewPluginWeb();
    channel.setMethodCallHandler(instance._handleMessages);
  }

  Future<dynamic> _handleMessages(MethodCall call) async {
    switch (call.method) {
      case 'onState':
        final String url = call.arguments['url'];
        print('Hello World! $url');
        break;
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The url_launcher plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }
}
