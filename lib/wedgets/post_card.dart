import 'package:flutter/material.dart';
import 'package:instegram_clone/Model/user.dart';
import 'package:instegram_clone/providers/user_provider.dart';
import 'package:instegram_clone/resources/firestore_methods.dart';
import 'package:instegram_clone/screens/comment_screen.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:instegram_clone/wedgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // - Post header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profileUrl']),
                  radius: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      widget.snap['username'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          children: [
                            'Delete',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    FirestoreMethods()
                                        .deletePost(widget.snap['postId']);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likeImage(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['photoUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    smallLike: false,
                    duration: const Duration(milliseconds: 700),
                    child: const Icon(
                      Icons.favorite,
                      size: 120,
                      color: Colors.white,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likeImage(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '  ${widget.snap['description']}')
                      ])),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                      'View all 200 comments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['uploadDate'].toDate()),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
