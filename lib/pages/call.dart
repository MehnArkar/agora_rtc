import 'package:agora_rtc/utils/setting.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class CallPage extends StatefulWidget {
  final String? channelName;
  final ClientRoleType? clientRoleType;
  const CallPage({super.key,this.channelName,this.clientRoleType});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late AgoraClient client;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: appId,
        channelName: widget.channelName!,
        tempToken: token,
        uid: 1,
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
        body: SafeArea(
          child: Stack(
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
      ),
    );
  }
}
