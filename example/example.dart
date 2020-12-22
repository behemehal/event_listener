// @dart=2.9
import 'package:event_listener/event_listener.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  var downloadEmitter = EventListener();
  var fileToDownload =
      'http://ipv4.download.thinkbroadband.com/5MB.zip'; //Test file

  final client = http.Client();
  var response = client.send(http.Request('GET', Uri.parse(fileToDownload)));
  var downloaded = 0;

  var logger = (percent) {
    print('Percent: ${percent}%');
  };

  downloadEmitter.on('download', logger);

  response.asStream().listen((http.StreamedResponse r) {
    r.stream.listen((List<int> chunk) {
      downloadEmitter.emit(
          'download', (downloaded / r.contentLength * 100).floor());
      downloaded += chunk.length;
    }, onDone: () async {
      downloadEmitter.emit(
          'download', (downloaded / r.contentLength * 100).floor());
      downloadEmitter.removeEventListener('download', logger);
      print('Download complete removed listener');
      return;
    });
  });
}
