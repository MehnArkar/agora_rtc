// import 'package:agora_rtc/utils/setting.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int? _remoteUid; // uid of the remote user
//   bool _isJoined = false; // Indicates if the local user has joined the channel
//   late RtcEngine agoraEngine;
//
//   late final MediaPlayerController _mediaPlayerController;
//   String mediaLocation =
//       "https://www.appsloveworld.com/wp-content/uploads/2018/10/640.mp4";
//
//   bool _isUrlOpened = false; // Media file has been opened
//   bool _isPlaying = false; // Media file is playing
//   bool _isPaused = false; // Media player is paused
//
//   int _duration = 0; // Total duration of the loaded media file
//   int _seekPos = 0; // Agora engine instance
//
//   final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
//
//   showMessage(String message) {
//     scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Set up an instance of Agora engine
//     setupVideoSDKEngine();
//   }
//
//   // Release the resources when you leave
//   @override
//   void dispose() async {
//     await agoraEngine.leaveChannel();
//     agoraEngine.release();
//     super.dispose();
//   }
//
//   Future<void> setupVideoSDKEngine() async {
//     // retrieve or request camera and microphone permissions
//     await [Permission.microphone, Permission.camera].request();
//
//     //create an instance of the Agora engine
//     agoraEngine = createAgoraRtcEngine();
//     await agoraEngine.initialize(const RtcEngineContext(
//         appId: appId
//     ));
//
//     await agoraEngine.enableVideo();
//
//     // Register the event handler
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           showMessage("Local user uid:${connection.localUid} joined the channel");
//           setState(() {
//             _isJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           showMessage("Remote user uid:$remoteUid joined the channel");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           showMessage("Remote user uid:$remoteUid left the channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );
//   }
//
//
//
//
// // Build UI
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: scaffoldMessengerKey,
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Get started with Video Calling'),
//           ),
//           body: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             children: [
//               _mediaPLayerButton(),
//               Slider(
//                   value: _seekPos.toDouble(),
//                   min: 0,
//                   max: _duration.toDouble(),
//                   divisions: 100,
//                   label: '${(_seekPos / 1000.round())} s',
//                   onChanged: (double value) {
//                     _seekPos = value.toInt();
//                     _mediaPlayerController.seek(_seekPos);
//                     setState(() {});
//                   }),
//               // Container for the local video
//               Container(
//                 height: 240,
//                 decoration: BoxDecoration(border: Border.all()),
//                 child: Center(child: _localPreview()),
//               ),
//               const SizedBox(height: 10),
//               //Container for the Remote video
//               Container(
//                 height: 240,
//                 decoration: BoxDecoration(border: Border.all()),
//                 child: Center(child: _remoteVideo()),
//               ),
//               // Button Row
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isJoined ? null : () => {join()},
//                       child: const Text("Join"),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isJoined ? () => {leave()} : null,
//                       child: const Text("Leave"),
//                     ),
//                   ),
//                 ],
//               ),
//               // Button Row ends
//             ],
//           )),
//     );
//   }
//
// // Display local video preview
//   Widget _localPreview() {
//     if (_isJoined) {
//       if (_isPlaying) {
//         return AgoraVideoView(
//           controller: _mediaPlayerController,
//         );
//       } else {
//         return AgoraVideoView(
//           controller: VideoViewController(
//             rtcEngine: agoraEngine,
//             canvas: VideoCanvas(uid: 0),
//           ),
//         );
//       }
//     } else {
//       return const Text(
//         'Join a channel',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
//
//
// // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: agoraEngine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: channelName),
//         ),
//       );
//     } else {
//       String msg = '';
//       if (_isJoined) msg = 'Waiting for a remote user to join';
//       return Text(
//         msg,
//         textAlign: TextAlign.center,
//       );
//     }
//   }
//
//   void  join() async {
//     await agoraEngine.startPreview();
//     // Set channel options including the client role and channel profile
//     ChannelMediaOptions options = const ChannelMediaOptions(
//       clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     );
//
//     await agoraEngine.joinChannel(
//       token: token,
//       channelId: channelName,
//       options: options,
//       uid: 1,
//     );
//   }
//
//   void leave() {
//     setState(() {
//       _isJoined = false;
//       _remoteUid = null;
//     });
//     agoraEngine.leaveChannel();
//
//     // Dispose the media player
//     _mediaPlayerController.dispose();
//
//     setState(() {
//       _isPlaying = false;
//     });
//
//     _isUrlOpened = false;
//     _isPaused = false;
//   }
//
//
//   Widget _mediaPLayerButton() {
//     String caption = "";
//
//     if (!_isUrlOpened) {
//       caption = "Open media file";
//     } else if (_isPaused) {
//       caption = "Resume playing media";
//     } else if (_isPlaying) {
//       caption = "Pause playing media";
//     } else {
//       caption = "Play media file";
//     }
//
//     return ElevatedButton(
//       onPressed: _isJoined ? () => {playMedia()} : null,
//       child: Text(caption),
//     );
//   }
//
//
//   void playMedia() async {
//     if (!_isUrlOpened) {
//       await initializeMediaPlayer();
//       // Open the media file
//       _mediaPlayerController.open(url:mediaLocation, startPos:0);
//     } else if (_isPaused) {
//       // Resume playing
//       _mediaPlayerController.resume();
//       setState(() {
//         _isPaused = false;
//       });
//     } else if (_isPlaying) {
//       // Pause media player
//       _mediaPlayerController.pause();
//       setState(() {
//         _isPaused = true;
//       });
//     } else {
//       // Play the loaded media file
//       _mediaPlayerController.play();
//       setState(() {
//         _isPlaying = true;
//         updateChannelPublishOptions(_isPlaying);
//       });
//     }
//   }
//
//
//   Future<void> initializeMediaPlayer() async {
//     _mediaPlayerController= MediaPlayerController(
//         rtcEngine: agoraEngine,
//         useAndroidSurfaceView: true,
//         canvas: VideoCanvas(uid: 0,
//             sourceType: VideoSourceType.videoSourceMediaPlayer
//         )
//     );
//
//     await _mediaPlayerController.initialize();
//
//     _mediaPlayerController.registerPlayerSourceObserver(
//       MediaPlayerSourceObserver(
//         onCompleted: () {
//
//         },
//         onPlayerSourceStateChanged:
//             (MediaPlayerState state, MediaPlayerError ec) async {
//           showMessage(state.name);
//
//           if (state == MediaPlayerState.playerStateOpenCompleted) {
//             // Media file opened successfully
//             _duration = await _mediaPlayerController.getDuration();
//             setState(() {
//               _isUrlOpened = true;
//             });
//           } else if (state == MediaPlayerState.playerStatePlaybackAllLoopsCompleted) {
//             // Media file finished playing
//             setState(() {
//               _isPlaying = false;
//               _seekPos = 0;
//               // Restore camera and microphone streams
//               updateChannelPublishOptions(_isPlaying);
//             });
//           }
//         },
//         onPositionChanged: (int position) {
//           setState(() {
//             _seekPos = position;
//           });
//         },
//         onPlayerEvent:
//             (MediaPlayerEvent eventCode, int elapsedTime, String message) {
//           // Other events
//         },
//       ),
//     );
//   }
//
//
//   void updateChannelPublishOptions(bool publishMediaPlayer) {
//     ChannelMediaOptions channelOptions = ChannelMediaOptions(
//         publishMediaPlayerAudioTrack: publishMediaPlayer,
//         publishMediaPlayerVideoTrack: publishMediaPlayer,
//         publishMicrophoneTrack: !publishMediaPlayer,
//         publishCameraTrack: !publishMediaPlayer,
//         publishMediaPlayerId: _mediaPlayerController.getMediaPlayerId());
//
//     agoraEngine.updateChannelMediaOptions(channelOptions);
//   }
//
//
//
//
// }

import 'package:agora_rtc/pages/create_meeting_page.dart';
import 'package:agora_rtc/pages/join_meeting_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite, 45),
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                  ),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CreateMeetingPage()));
                  },
                  child: const Text('Create Meeting',style: TextStyle(color: Colors.white),)),
              const SizedBox(height: 15,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite, 45),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Theme.of(context).primaryColor,width: 1.5)
                  ),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const JoinMeetingPage()));
                  },
                  child:  Text('Join Meeting',style: TextStyle(color: Theme.of(context).primaryColor),)),
            ],
          ),
        ),
      ),
    );
  }
}
