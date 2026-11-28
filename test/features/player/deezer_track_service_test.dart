import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_3/features/player/services/deezer_track_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

DeezerTrackService serviceWith(
  Future<http.Response> Function(http.Request request) handler,
) {
  return DeezerTrackService(client: MockClient(handler));
}

DeezerTrackService serviceReturning(int status, String body) {
  return serviceWith((_) async => http.Response(body, status));
}

Matcher throwsDeezer(String message) {
  return throwsA(
    isA<DeezerTrackException>().having((e) => e.message, 'message', message),
  );
}

void main() {
  group('DeezerTrackService.fetchPreviewUrl', () {
    test('mengembalikan url preview dari respons 200 yang valid', () async {
      final service = serviceReturning(
        200,
        jsonEncode({'id': 3135556, 'preview': 'https://cdn.example/a.mp3'}),
      );

      expect(
        await service.fetchPreviewUrl('3135556'),
        'https://cdn.example/a.mp3',
      );
    });

    test('memanggil endpoint track Deezer dengan id yang diberikan', () async {
      late Uri requested;
      final service = serviceWith((request) async {
        requested = request.url;
        return http.Response(jsonEncode({'preview': 'https://x/a.mp3'}), 200);
      });

      await service.fetchPreviewUrl('916424');

      expect(requested.scheme, 'https');
      expect(requested.host, 'api.deezer.com');
      expect(requested.path, '/track/916424');
    });

    test('melempar exception saat preview kosong', () {
      final service = serviceReturning(200, jsonEncode({'preview': ''}));

      expect(
        service.fetchPreviewUrl('1'),
        throwsDeezer('Lagu ini tidak punya preview'),
      );
    });

    test('melempar exception saat field preview tidak ada', () {
      final service = serviceReturning(200, jsonEncode({'id': 1}));

      expect(
        service.fetchPreviewUrl('1'),
        throwsDeezer('Lagu ini tidak punya preview'),
      );
    });

    test('melempar exception saat preview bukan string', () {
      final service = serviceReturning(200, jsonEncode({'preview': 123}));

      expect(
        service.fetchPreviewUrl('1'),
        throwsDeezer('Lagu ini tidak punya preview'),
      );
    });

    test('melempar exception saat Deezer mengirim objek error', () {
      final service = serviceReturning(
        200,
        jsonEncode({
          'error': {'type': 'DataException', 'message': 'no data', 'code': 800},
        }),
      );

      expect(
        service.fetchPreviewUrl('0'),
        throwsDeezer('Lagu tidak ditemukan di Deezer'),
      );
    });

    test('melempar exception saat body bukan objek JSON', () {
      final service = serviceReturning(200, jsonEncode([1, 2, 3]));

      expect(
        service.fetchPreviewUrl('1'),
        throwsDeezer('Lagu tidak ditemukan di Deezer'),
      );
    });

    test('melempar exception saat JSON rusak', () {
      final service = serviceReturning(200, '{bukan json');

      expect(
        service.fetchPreviewUrl('1'),
        throwsDeezer('Respons Deezer tidak valid'),
      );
    });

    test('melempar exception saat status 404', () {
      final service = serviceReturning(404, '');

      expect(service.fetchPreviewUrl('1'), throwsDeezer('Deezer error 404'));
    });

    test('melempar exception saat status 500', () {
      final service = serviceReturning(500, '');

      expect(service.fetchPreviewUrl('1'), throwsDeezer('Deezer error 500'));
    });

    test('melempar exception saat terjadi TimeoutException', () {
      final service = serviceWith((_) async => throw TimeoutException('lama'));

      expect(
        service.fetchPreviewUrl('1'),
        throwsDeezer('Koneksi ke Deezer timeout'),
      );
    });

    test('melempar exception saat terjadi SocketException', () {
      final service = serviceWith(
        (_) async => throw const SocketException('putus'),
      );

      expect(
        service.fetchPreviewUrl('1'),
        throwsDeezer('Tidak ada koneksi internet'),
      );
    });

    test('melempar exception saat terjadi ClientException', () {
      final service = serviceWith(
        (_) async => throw http.ClientException('gagal'),
      );

      expect(
        service.fetchPreviewUrl('1'),
        throwsDeezer('Tidak ada koneksi internet'),
      );
    });
  });
}
