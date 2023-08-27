import 'dart:developer';
import 'package:agora_rtc/pages/calling_page.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRoleType ? _role = ClientRoleType.clientRoleBroadcaster;

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora RTC'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                errorText: _validateError?'Channel Name is mandatory':null,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1)
                )
              )
            ),
          RadioListTile(
            title: Text('Broadcaster'),
              value: ClientRoleType.clientRoleBroadcaster,
              groupValue: _role,
              onChanged: (ClientRoleType? roleType){
               setState(() {
                 _role = roleType;
               });
              }),
          RadioListTile(
            title: Text('Audience'),
              value: ClientRoleType.clientRoleAudience,
              groupValue: _role,
              onChanged: (ClientRoleType? roleType){
                setState(() {
                  _role = roleType;
                });
              }),
          ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40)
              ),
            child: Text('Join'),

          )

        ],
      ),
    );
  }

  Future<void> onJoin() async{
    setState(()  {
      _validateError = _channelController.text.isEmpty?true:false;
    });
    if(_channelController.text.isNotEmpty) {
      await handelCameraAndMic(Permission.camera);
      await handelCameraAndMic(Permission.microphone);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>CallingPage(channelName: _channelController.text,clientRoleType: ClientRoleType.clientRoleBroadcaster,)));
    }
  }

  Future<void> handelCameraAndMic(Permission permission) async{
      final status = await permission.request();
      log(status.toString());
  }

}
