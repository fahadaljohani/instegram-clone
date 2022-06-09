import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:instegram_clone/resources/firestore_methods.dart';
import 'package:instegram_clone/resources/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:instegram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:instegram_clone/Model/user.dart';
import 'package:instegram_clone/providers/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  // - Properties
  Uint8List? _file;
  bool isLoading = false;
  late TextEditingController _descController;
  // - Methods
  selectImage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(20),
            title: const Text('Choose a photo'),
            children: [
              SimpleDialogOption(
                child: const Text('Select From gallery'),
                onPressed: () async {
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: const Text('Select From camera'),
                onPressed: () async {
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  clearPost() {
    setState(() => _file = null);
  }

  postImage(
      String username, String uid, Uint8List file, String profileUrl) async {
    setState(() {
      isLoading = true;
    });
    String postUrl = await StorageMethods()
        .uploadImageToStorage(file: file, childName: 'posts', isPost: true);
    String result = await FirestoreMethods()
        .postImage(uid, _descController.text, username, profileUrl, postUrl);

    setState(() {
      isLoading = false;
    });
    if (result != "success") {
      showSnackBar(context, result);
    } else {
      showSnackBar(context, "Posted");
      clearPost();
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser();
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text('Post to'),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearPost,
              ),
              actions: [
                TextButton(
                    onPressed: () => postImage(
                        user.username, user.uid, _file!, user.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(children: [
              isLoading == true
                  ? const LinearProgressIndicator(
                      color: blueColor,
                    )
                  : const Padding(
                      padding: EdgeInsets.only(
                        top: 0,
                      ),
                    ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      controller: _descController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                          hintText: 'Enter caption...',
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          );
  }
}
