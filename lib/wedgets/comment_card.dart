import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final String text;
  final String username;
  final String profileUrl;
  final publishedDate;
  const CommentCard(
      {Key? key,
      required this.profileUrl,
      required this.username,
      required this.text,
      required this.publishedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileUrl),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(text: '  $text'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(publishedDate.toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite_border_outlined,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
