import 'dart:io';

import 'package:phoenixa/phoenixa.dart';

void main() {
  const port = 8080;
  final localhost = InternetAddress.loopbackIPv4;

  Phoenixa server = Phoenixa();
  server.listen(
    address: localhost,
    port: port,
    callback: () => print('Server has started on $localhost:$port'),
  );

  server.route(
    method: 'get',
    path: '/',
    callback: (req, res) {
      res.sendFile(path: 'lib/public/index.html', mime: 'text/html');
    },
  );

  server.route(
    method: 'get',
    path: '/styles.css',
    callback: (req, res) {
      res.sendFile(path: 'lib/public/styles.css', mime: 'text/css');
    },
  );

  server.route(
    method: 'get',
    path: '/scripts.js',
    callback: (req, res) {
      res.sendFile(path: 'lib/public/scripts.js', mime: 'text/javascript');
    },
  );

  server.route(
    method: 'post',
    path: '/login',
    callback: (req, res) {
      res.setStatus(400).sendJson({'message': 'Bad login info'});
    },
  );
}
