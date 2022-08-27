import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:lpat/Firebase/FirebaseDatabaseService.dart';
import 'package:lpat/Firebase/FirebaseStorageService.dart';
import 'package:lpat/Objects/AudioFileObject.dart';
import 'package:lpat/Objects/CustomerObject.dart';
import 'package:lpat/Screens/NotificationScreen.dart';
import 'package:lpat/Screens/SettingsScreen.dart';
import 'package:lpat/Utils/Colors.dart';
import 'package:lpat/Utils/Global.dart';
import 'package:lpat/Utils/UtilWidgets.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioFileObject audioFile;
  bool audioplayed = false;
  AudioPlayer player = AudioPlayer();
  // var file;

  Future<void> getCustomer() async {
    CustomerObject customerObject =
        await FirebaseDatabaseService().getSingleCustomer();

    String customerImageName = await FirebaseStorageService()
        .getCustomerImageLink(customerObject.customerImageName);
    customerObject.customerImageName = customerImageName;
    if (customerObject != null) {
      setState(() {
        customer = customerObject;
      });
    }
  }

  String buttonToDisplay = 'images/audio_play_button.png';

  int selectedIndex = 0;

  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  bool isplaying = false, isPause = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Future<void> getAudioFile() async {
    AudioFileObject audioFileData =
        await FirebaseDatabaseService().getAudioFile();
    print(audioFileData.location);
    // var data =
    //     await FirebaseCacheManager().getSingleFile(audioFileData.location);
    // var fileData = await FirebaseCacheManager()
    //     .getSingleFile('gs://endlich-gelassen-leben-2559b.appspot.com/sound/');
    if (audioFileData != null) {
      setState(() {
        // file = data;
        audioFile = audioFileData;
      });
    }
  }

  void play() async {
    if (!isplaying && !audioplayed) {
      // if (file != null) {
      //   int result = await player.play(file);
      int result = await player.play(
          'https://firebasestorage.googleapis.com/v0/b/endlich-gelassen-leben-2559b.appspot.com/o/sound%2FAnleitung%20zum%20Entspannen.mp3?alt=media&token=b5f571f0-0aa1-4bca-910d-8542e1909574');
      if (result == 1) {
        //play success
        setState(() {
          buttonToDisplay = 'images/audio_pause_logo.png';
          isplaying = true;
          audioplayed = true;
        });
      } else {
        print("Error while playing audio.");
      }
      // }
    } else if (audioplayed && !isplaying) {
      int result = await player.resume();
      if (result == 1) {
        //resume success
        setState(() {
          isplaying = true;
          audioplayed = true;
        });
      } else {
        print("Error on resume audio.");
      }
    } else {
      int result = await player.pause();
      if (result == 1) {
        //pause success
        setState(() {
          isplaying = false;
        });
      } else {
        print("Error on pause audio.");
      }
    }

    // // print(audioFile.location);
    // if (isplaying) {
    //   await audioPlayer.pause();
    // } else if (isPause) {
    //   await audioPlayer.resume();
    // } else {
    //   if (audioFile != null) {
    //     int result = await audioPlayer.play(audioFile.location);
    //     if (result == 1) {
    //       // success
    //
    //     }
    //   }
    // }
  }

  Future<void> getShareMessage() async {
    String messageData = await FirebaseDatabaseService().getShareMessage();
    if (messageData != null) {
      setState(() {
        shareMessage = messageData;
      });
    }
  }

  Future<String> permissionStatusFuture;

  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";

  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return null;
      }
    });
  }

  @override
  initState() {
    super.initState();
    getCustomer();
    getAudioFile();
    Wakelock.enable();
    getShareMessage();

    NotificationPermissions.requestNotificationPermissions(
            iosSettings: const NotificationSettingsIos(
                sound: true, badge: true, alert: true))
        .then((value) => {
              setState(() {
                permissionStatusFuture = getCheckNotificationPermStatus();
              }),
            });

    player.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.COMPLETED) {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            // <-- SEE HERE
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30.0),
            ),
          ),
          builder: (context) {
            return showBottomSheetView();
          },
        );
      }
      setState(() {
        isplaying = event == PlayerState.PLAYING;
        isPause = event == PlayerState.PAUSED;
      });
    });

    player.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    player.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  backgroundView(),
                  selectedIndex == 0
                      ? _bodyView()
                      : selectedIndex == 1
                          ? NotificationScreen()
                          : SettingsScreen(),
                ],
              ),
            ),
            if (selectedIndex != 0) _bottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    return SafeArea(
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: pureWhiteColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 45,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _singleBottomTab(index: 0),
            _singleBottomTab(index: 1),
            _singleBottomTab(index: 2),
          ],
        ),
      ),
    );
  }

  Widget _singleBottomTab({@required int index}) {
    return GestureDetector(
      onTap: () => {
        setState(() {
          selectedIndex = index;
        })
      },
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: selectedIndex == index ? darkBlueColor : pureWhiteColor,
          borderRadius: BorderRadius.circular(105),
        ),
        child: Row(
          children: [
            Image.asset(
              selectedIndex == index
                  ? bottomItems[index].image
                  : bottomItems[index].imageInactive,
              width: 24,
            ),
            if (selectedIndex == index)
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    bottomItems[index].label,
                    style: const TextStyle(
                      color: pureWhiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 25),

        // width: MediaQuery.of(context).size.width,
        // color: pureWhiteColor,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 230,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Audio Abspielen',
                          style: TextStyle(
                            color: pureBlackColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Image.asset(
                          'images/logo.png',
                          height: 190,
                        ),
                        const SizedBox(
                          height: 11,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            height: 36,
                          ),
                          Text(
                            audioFile != null
                                ? audioFile.subTitle
                                : 'Anleitung zur',
                            style: const TextStyle(
                              color: pureBlackColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            audioFile != null
                                ? audioFile.displayName
                                : 'Blitzentspannung',
                            style: const TextStyle(
                              color: pureBlackColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            audioFile != null
                                ? audioFile.details
                                : 'klicken und entspannen',
                            style: const TextStyle(
                              color: pureBlackColor,
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 75,
                          ),
                          Slider(
                            min: 0,
                            activeColor: darkBlueColor,
                            inactiveColor: const Color(0x500B1222),
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              setState(() {
                                position = Duration(seconds: value.toInt());
                              });
                              await player.seek(position);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDuration(position),
                                  style: const TextStyle(
                                    color: pureBlackColor,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  formatDuration(duration),
                                  style: const TextStyle(
                                    color: pureBlackColor,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          GestureDetector(
                            onTap: play,
                            child: Container(
                              color: Colors.transparent,
                              child: Image.asset(
                                isplaying
                                    ? buttonToDisplay
                                    : 'images/audio_play_logo.png',
                                height: 120,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _bottomNavigation(),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 240,
            child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
