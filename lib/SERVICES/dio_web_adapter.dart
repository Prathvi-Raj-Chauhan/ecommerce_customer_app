import 'package:dio/dio.dart';
import 'package:dio/browser.dart';

HttpClientAdapter getAdapter() {
  final adapter = BrowserHttpClientAdapter();
  adapter.withCredentials = true;
  return adapter;
}
