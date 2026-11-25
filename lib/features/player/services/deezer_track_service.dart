import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class DeezerTrackException implements Exception {
  final String message;

  const DeezerTrackException(this.message);

  @override
  String toString() => message;
}

class DeezerTrackService {
  final http.Client _client;

  DeezerTrackService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> fetchPreviewUrl(String trackId) async {
    final http.Response response;
    try {
      response = await _client
          .get(Uri.https('api.deezer.com', '/track/$trackId'))
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const DeezerTrackException('Koneksi ke Deezer timeout');
    } on SocketException {
      throw const DeezerTrackException('Tidak ada koneksi internet');
    } on http.ClientException {
      throw const DeezerTrackException('Tidak ada koneksi internet');
    }

    if (response.statusCode != 200) {
      throw DeezerTrackException('Deezer error ${response.statusCode}');
    }

    final Object? body;
    try {
      body = jsonDecode(response.body);
    } on FormatException {
      throw const DeezerTrackException('Respons Deezer tidak valid');
    }

    if (body is! Map<String, dynamic> || body['error'] != null) {
      throw const DeezerTrackException('Lagu tidak ditemukan di Deezer');
    }

    final preview = body['preview'];
    if (preview is! String || preview.isEmpty) {
      throw const DeezerTrackException('Lagu ini tidak punya preview');
    }
    return preview;
  }

  void dispose() => _client.close();
}
