import 'dart:convert';

import 'package:http/http.dart' as http;

var client = http.Client();


Future<String> getToken(String channelId,bool isHost,int userId,Duration expiredTime) async{
  String token = '';
  String role = isHost?'publisher':'audience';
  int expiredTimeInSecond = expiredTime.inSeconds;
  var response = await client.get(Uri.parse('https://agora-node-tokenserver.onrender.com/rtc/$channelId}/$role/uid/$userId/?expiry=$expiredTimeInSecond'));
  token = jsonDecode(response.body)['rtcToken'].toString();
  return token;
}