part of syslog;

DateFormat _format = new DateFormat('MMM d HH:mm:ss');

class _Syslog extends Syslog {
  RawDatagramSocket _socket;
  int _port;
  var _hostname;
  
  _Syslog(RawDatagramSocket socket, hostname, int port): 
    _socket = socket, 
    _hostname = hostname, 
    _port = port;
  
  static Future<Syslog> open (hostname, {int port: 514}) { 
    const int randomPort = 0;
    return RawDatagramSocket.bind(hostname, randomPort)
        .then((RawDatagramSocket socket) => new _Syslog(socket, hostname, port));
  }
  
  void log(int facility, int Severity, String message, {DateTime timestamp, String hostname : '', String appname: ''}) {
    int priority = _Syslog._priority(facility, Severity);
    String trimmedHostname = hostname.trim();
    String trimmedAppname = appname.trim();
    
    String time = timestamp != null ? '${_format.format(timestamp)} ': '${_format.format(new DateTime.now())} ';
    String host = hostname == null || trimmedHostname == ''  ? '' : '${trimmedHostname} ';
    String app = appname == null || trimmedAppname == '' ? '' : '${trimmedAppname}';
    
    String sysMsg = '<${priority}>${time}${host}${app}[${pid}]: ${message}';
    if(sysMsg.length > 1024) {
      throw('Message to long');
    }
    _socket.send(sysMsg.codeUnits, _hostname, _port);
  }
  
  void close() {
    _socket.close();
  }
  
  static int _priority(int facility, int severity) => facility * 8 + severity;
}