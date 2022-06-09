import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instegram_clone/providers/user_provider.dart';
import 'package:instegram_clone/resources/firestore_methods.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:instegram_clone/utils/utils.dart';
import 'package:instegram_clone/wedgets/comment_card.dart';
import 'package:provider/provider.dart';
import 'package:instegram_clone/Model/user.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late TextEditingController _textController;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).getUser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comment To'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'no comment yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              final snap = (snapshot.data! as dynamic).docs[index];
              return CommentCard(
                username: snap['username'],
                profileUrl: snap['profileUrl'],
                text: snap['text'],
                publishedDate: snap['publishedData'],
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _textController,
                    autocorrect: false,
                    // maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().addComment(
                      widget.snap['postId'],
                      _textController.text,
                      user.uid,
                      user.username,
                      user.photoUrl);
                  _textController.text = '';
                  showSnackBar(context, 'comment added');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: blueColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
