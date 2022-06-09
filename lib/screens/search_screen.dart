import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instegram_clone/screens/profile_screen.dart';
import 'package:instegram_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchuserController = TextEditingController();
  bool formSubmitted = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchuserController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
            controller: _searchuserController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Search for Users',
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                formSubmitted = true;
              });
            }),
      ),
      body: formSubmitted
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchuserController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid: snapshot.data!.docs[index]['uid']))),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                                snapshot.data!.docs[index]['profilePhoto']),
                          ),
                          title: Text(
                            snapshot.data!.docs[index]['username'],
                          ),
                        ),
                      );
                    });
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('uploadDate', descending: true)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    return Image.network(
                      snapshot.data!.docs[index]['photoUrl'],
                      fit: BoxFit.cover,
                    );
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0) ? 2 : 1,
                    (index % 7 == 0) ? 2 : 1,
                  ),
                );
                // return GridView.builder(
                //     itemCount: snapshot.data!.docs.length,
                //     gridDelegate:
                //         const SliverGridDelegateWithFixedCrossAxisCount(
                //             childAspectRatio: 4 / 3,
                //             crossAxisCount: 3,
                //             crossAxisSpacing: 4,
                //             mainAxisSpacing: 4),
                //     itemBuilder: (context, index) {
                //       return Image.network(
                //         snapshot.data!.docs[index]['photoUrl'],
                //         fit: BoxFit.cover,
                //       );
                //     });
              }),
    );
  }
}
