import 'package:client/key.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_gemini/google_gemini.dart';
import 'dart:io';

class ImageCam extends StatefulWidget {
  const ImageCam({super.key});

  @override
  State<ImageCam> createState() => _ImageCamState();
}

class _ImageCamState extends State<ImageCam> {
  List textandImageChat = [];
  bool loading = false;

  File? imageFile;

  final TextEditingController _textController =
      TextEditingController(); //input text(query)
  final ScrollController _scroll =
      ScrollController(); //scrolling to the latest msg

  late CameraController _cameraController;
  late List<CameraDescription> cameras;

  final ImagePicker picker = ImagePicker();

  File? imagePreview;

  final gemini = GoogleGemini(apiKey: GPTKey.GapiKey);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  //initializing camera
  Future<void> _initializeCamera() async {
    if (await Permission.camera.request().isGranted) {
      try {
        cameras = await availableCameras();

        if (cameras.isNotEmpty) {
          _cameraController = CameraController(cameras[0], ResolutionPreset.max,
              imageFormatGroup: ImageFormatGroup.yuv420);

          await _cameraController.initialize();
        } else {
          print("no cameras available");
        }
      } catch (e, stackTrace) {
        print("Error initializing camera: $e");
        print("Stack Trace: $stackTrace");
      }
    } else {
      print("Permission Denied");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

//capture image using camera
  Future<void> _captureImage() async {
    if (!_cameraController.value.isInitialized) {
      await _initializeCamera();
    }

    if (_cameraController.value.isInitialized) {
      try {
        XFile capturedImage = await _cameraController.takePicture();
        setState(() {
          imageFile = File(capturedImage.path);
        });
      } catch (e) {
        print("Error capturing image: $e");
      }
    }
  }

  void queryTextAndImage({required String query, required File image}) {
    //sets the state of loader->true
    //adds query to textandImageChat list based on role
    setState(() {
      loading = true;
      textandImageChat.add({
        "role": "User",
        "text": query,
        "image": image,
      });
      _textController.clear();
      imageFile = null;
    });
    scrollToEnd();

    //using the gemini instance to call function
    //query passed as parameter and response taken as value
    gemini.generateFromTextAndImages(query: query, image: image).then((value) {
      //sets state of loader->false ie loader wont be displayed any more
      //adds respone value to textandImageChat list based on role(gemini)
      setState(() {
        loading = false;
        textandImageChat
            .add({"role": "Gemini", "text": value.text, "image": ""});
      });
      scrollToEnd();
    }).onError((error, stackTrace) {
      //loader->false; it will stop showing up on screen
      //error will added to chat from Gemini's side
      loading = false;
      textandImageChat.add({
        "role": "Gemini",
        "text": error.toString(),
        "image": "",
      });
      scrollToEnd();
    });
  }

  //function to bring the chat screen to latest text msg
  void scrollToEnd() {
    _scroll.jumpTo(_scroll.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              itemCount: textandImageChat
                  .length, //count of tiles == number of items in textandImageChat List
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,

                  title: textandImageChat[index]["image"] == ""
                      ? null
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              imagePreview = textandImageChat[index]["image"];
                            });
                            _showImagePreview(context);
                          },
                          child: Image.file(
                            textandImageChat[index]["image"],
                            width: 80,
                          ),
                        ), //username=>role
                  subtitle: textandImageChat[index]["role"] == "User"
                      ? Text(
                          textandImageChat[index]["text"],
                          style: TextStyle(color: Colors.transparent),
                        )
                      : Text(textandImageChat[index]["text"]), //chat=>text
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Type your Prompt..",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none),
                      fillColor: Colors.transparent,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt_rounded),
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  child: CameraPreview(_cameraController),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Close the bottom sheet and capture the image
                                  Navigator.of(context).pop();
                                  _captureImage();
                                },
                                child: Text('Capture'),
                              )
                            ],
                          );
                        });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () async {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      imageFile = image != null ? File(image.path) : null;
                    });
                  },
                ),
                IconButton(
                    onPressed: () {
                      if (imageFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select an image")));
                        return;
                      }
                      queryTextAndImage(
                          query:
                              "What is the category of this place? Give me description and History of this place. Also tell me where this place is possibly located at? Generate the answer in about 150 words.",
                          image: imageFile!);
                    },
                    icon: loading
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.send,
                            color: Colors.deepPurple,
                          ))
              ],
            ),
          )
        ]),
        floatingActionButton: imageFile != null
            ? Container(
                margin: EdgeInsets.only(bottom: 80),
                height: 150,
                child: Image.file(imageFile ?? File("")),
              )
            : null);
  }

//image ka preview
  void _showImagePreview(BuildContext context) {
    if (imagePreview != null) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
          body: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.file(
                imagePreview!,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      }));
    }
  }
}
