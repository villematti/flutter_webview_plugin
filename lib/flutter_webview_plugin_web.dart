import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

const _kChannel = 'flutter_webview_plugin';

class FlutterWebViewPlugin {
  final _onUrlChanged = StreamController<String>.broadcast();

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        _kChannel, const StandardMethodCodec(), registrar.messenger);
    final FlutterWebViewPlugin instance = FlutterWebViewPlugin();
    channel.setMethodCallHandler(instance._handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case '_onUrlChanged':
        return _onUrlChanged.add(call.arguments['url']);
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The url_launcher plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  Stream<String> get onUrlChanged => _onUrlChanged.stream;
}
