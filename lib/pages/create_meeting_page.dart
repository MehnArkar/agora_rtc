import 'package:agora_rtc/pages/calling_page.dart';
import 'package:agora_rtc/services/api_service.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateMeetingPage extends StatefulWidget {
  const CreateMeetingPage({super.key});

  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  TextEditingController txtChannelName = TextEditingController();
  TextEditingController txtUserId = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: txtChannelName,
                  decoration: InputDecoration(
                    labelText: 'Meeting ID',
                    border: OutlineInputBorder()
                  ),

                ),
                const SizedBox(height: 15,),
                TextField(
                  controller: txtUserId,
                  decoration: InputDecoration(
                      labelText: 'Your ID',
                      border: OutlineInputBorder()
                  ),

                ),
                const SizedBox(height: 25,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.maxFinite, 45),
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                    ),
                    onPressed: () async{
                      String userId = txtUserId.text.trim();
                      String channelId = txtChannelName.text.trim();
                      if(userId.isNotEmpty && channelId.isNotEmpty){
                        setState(() {
                          isLoading = true;
                        });

                        String token = await getToken(channelId, true, int.parse(userId), const Duration(seconds: 3600));
                        print(token);

                        setState(() {
                          isLoading=false;
                        });

                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=>CallingPage(
                                  channelName: channelId,
                                  token: token,
                                  id: int.parse(userId),
                                  clientRoleType: ClientRoleType.clientRoleBroadcaster,
                                )
                            )
                        );
                      }
                    },
                    child:isLoading?const CupertinoActivityIndicator(color: Colors.white,): const Text('Create',style: TextStyle(color: Colors.white),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
