import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';

import 'logging_interceptor.dart';
import 'model/characters_response.dart';

class CaracterWebClient {
  final Client client = HttpClientWithInterceptor.build(
      interceptors: [LoggingInterceptor()],
      requestTimeout: Duration(seconds: 5));

  Future<CharactersResponse> getCaracters() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateMd5(timestamp +
            '' +
            '')
        .toString();
    final queryParameters = {
      'apikey': '',
      "hash": hash,
      "ts": timestamp,
      "limit": 21.toString(),
      "offset": 0.toString(),
    };
    final Uri baseUri = Uri.https(
        'gateway.marvel.com', '/v1/public/characters', queryParameters);
    try {
      final Response response = await client.get(baseUri);
      final jsonValue = jsonDecode(response.body);
      final caracters = CharactersResponse.fromJson(jsonValue);
      print("Resultado " + caracters.data.characters[2].name);

      return caracters;
    } catch (e) {
      print("Ocorreu um erro" + e.toString());
    }
  }

  generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
