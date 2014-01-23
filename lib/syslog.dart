library syslog;

import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';

part 'package:syslog/src/syslog.dart';

/**
 * Sends log messages over UDP to a syslog server.
 */
abstract class Syslog {    
  /**
   * Binds the Syslog class to a specified host for further logging.
   */
  static Future<Syslog> open(hostname, {int port: 514}) => _Syslog.open(hostname, port: port);
  
  /**
   * Performs a syslog to the currently bound syslog host.
   */
  void log(int facility, int level, String message, {DateTime timestamp, String hostname, String appname});
  
  /**
   * Closes the socket to the syslog server.
   */
  void close();
}

class Facility {
  static const int kern     = 0;
  static const int user     = 1;
  static const int mail     = 2;
  static const int daemon   = 3;
  static const int auth     = 4;
  static const int syslog   = 5;
  static const int LPR      = 6;
  static const int news     = 7;
  static const int UUCP     = 8;
  static const int clock    = 9;
  static const int authpriv = 10;
  static const int FTP      = 11;
  static const int NTP      = 12;
  static const int logAudit = 13;
  static const int logAlert = 14;
  static const int cron     = 15;
  static const int local0   = 16;
  static const int local1   = 17;
  static const int local2   = 18;
  static const int local3   = 19;
  static const int local4   = 20;
  static const int local5   = 21;
  static const int local6   = 22;
  static const int local7   = 23;
}

class Severity {
  static const int Emergency     = 0;
  static const int Alert         = 1;
  static const int Critical      = 2;
  static const int Error         = 3;
  static const int Warning       = 4;
  static const int Notice        = 5;
  static const int Informational = 6;
  static const int Debug         = 7;
}