import 'package:agora_rtc/utils/setting.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class CallingPage extends StatefulWidget {
  final String channelName;
  final String token;
  final int id;
  final ClientRoleType clientRoleType;
  const CallingPage({super.key,required this.channelName,required this.token,required this.id,required this.clientRoleType});

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  late AgoraClient client;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: appId,
        channelName: widget.channelName,
        tempToken: widget.token,
        uid: widget.id,
      ),
    );
    initAgora();

  }

  void initAgora() async {
    await client.initialize();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agora UI Kit'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
              showAVState: true,
              showNumberOfUsers: true,
            ),
            AgoraVideoButtons(
              client: client,
            ),
          ],
        ),
      ),
    );
  }
}
