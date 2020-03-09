import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_webview_plugin/src/javascript_channel.dart';

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
      case 'launch':
        final String url = call.arguments['url'];
        launch(url);
        break;
      case 'onState':
        print('Hello World! now on state!');
        break;
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details:
                "The flutter_webview_plugin plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  final Map<String, JavascriptChannel> _javascriptChannels =
      // ignoring warning as min SDK version doesn't support collection literals yet
      // ignore: prefer_collection_literals
      Map<String, JavascriptChannel>();

  Future<Null> launch(
    String url, {
    Map<String, String> headers,
    Set<JavascriptChannel> javascriptChannels,
    bool withJavascript,
    bool clearCache,
    bool clearCookies,
    bool mediaPlaybackRequiresUserGesture,
    bool hidden,
    bool enableAppScheme,
    Rect rect,
    String userAgent,
    bool withZoom,
    bool displayZoomControls,
    bool withLocalStorage,
    bool withLocalUrl,
    String localUrlScope,
    bool withOverviewMode,
    bool scrollBar,
    bool supportMultipleWindows,
    bool appCacheEnabled,
    bool allowFileURLs,
    bool useWideViewPort,
    String invalidUrlRegex,
    bool geolocationEnabled,
    bool debuggingEnabled,
    bool ignoreSSLErrors,
  }) async {
    final args = <String, dynamic>{
      'url': url,
      'withJavascript': withJavascript ?? true,
      'clearCache': clearCache ?? false,
      'hidden': hidden ?? false,
      'clearCookies': clearCookies ?? false,
      'mediaPlaybackRequiresUserGesture':
          mediaPlaybackRequiresUserGesture ?? true,
      'enableAppScheme': enableAppScheme ?? true,
      'userAgent': userAgent,
      'withZoom': withZoom ?? false,
      'displayZoomControls': displayZoomControls ?? false,
      'withLocalStorage': withLocalStorage ?? true,
      'withLocalUrl': withLocalUrl ?? false,
      'localUrlScope': localUrlScope,
      'scrollBar': scrollBar ?? true,
      'supportMultipleWindows': supportMultipleWindows ?? false,
      'appCacheEnabled': appCacheEnabled ?? false,
      'allowFileURLs': allowFileURLs ?? false,
      'useWideViewPort': useWideViewPort ?? false,
      'invalidUrlRegex': invalidUrlRegex,
      'geolocationEnabled': geolocationEnabled ?? false,
      'withOverviewMode': withOverviewMode ?? false,
      'debuggingEnabled': debuggingEnabled ?? false,
      'ignoreSSLErrors': ignoreSSLErrors ?? false,
    };

    if (headers != null) {
      args['headers'] = headers;
    }

    _assertJavascriptChannelNamesAreUnique(javascriptChannels);

    if (javascriptChannels != null) {
      javascriptChannels.forEach((channel) {
        _javascriptChannels[channel.name] = channel;
      });
    } else {
      if (_javascriptChannels.isNotEmpty) {
        _javascriptChannels.clear();
      }
    }

    args['javascriptChannelNames'] =
        _extractJavascriptChannelNames(javascriptChannels).toList();

    if (rect != null) {
      args['rect'] = {
        'left': rect.left,
        'top': rect.top,
        'width': rect.width,
        'height': rect.height,
      };
    }
  }

  void _assertJavascriptChannelNamesAreUnique(
      final Set<JavascriptChannel> channels) {
    if (channels == null || channels.isEmpty) {
      return;
    }

    assert(_extractJavascriptChannelNames(channels).length == channels.length);
  }

  Set<String> _extractJavascriptChannelNames(Set<JavascriptChannel> channels) {
    final Set<String> channelNames = channels == null
        // ignore: prefer_collection_literals
        ? Set<String>()
        : channels.map((JavascriptChannel channel) => channel.name).toSet();
    return channelNames;
  }
}
