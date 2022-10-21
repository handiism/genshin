import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genshin_app/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class _HomeState extends State<Home> {
  List<String> names = [];
  late Character character;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future _getCharNames() async {
    try {
      var response = await http.get(
        Uri.parse(
          "https://api.genshin.dev/characters",
        ),
      );

      names = charNameFromJson(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  Future _getCharacthers(name) async {
    try {
      var response = await http.get(
        Uri.parse(
          "https://api.genshin.dev/characters/$name",
        ),
      );

      character = characterFromJson(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        try {
          await _firebaseAuth.signOut().then(
            (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Signed Out"),
                ),
              );
              Navigator.pop(context);
            },
          );

          return false;
        } catch (e) {
          log(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sign Out Failed"),
            ),
          );
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Characters"),
          actions: [
            IconButton(
              onPressed: () {
                AlertDialog dialog = AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.network(
                            "https://pbs.twimg.com/profile_images/1495491360107171840/xlVxD_jN_400x400.jpg",
                            width: 200,
                          ),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text("Muhammad Handi Rachmawan"),
                        const Text("Software Engineer"),
                        const Text("Informatika, UPN Veteran Yogyakarta"),
                        const Text("mail.handira@gmail.com"),
                      ],
                    ),
                  ),
                );
                dialog.build(context);
                showDialog(context: context, builder: ((context) => dialog));
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        body: FutureBuilder(
          future: _getCharNames(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return _onConnectionDone(context, index);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: Icon(
                    Icons.signal_cellular_connected_no_internet_0_bar,
                  ),
                ),
                Center(child: Text("No internet connection."))
              ],
            );
          },
        ),
      ),
    );
  }

  _onConnectionDone(BuildContext context, int index) {
    return GestureDetector(
      child: ListTile(
        leading: CircleAvatar(
          child: Image.network(
            "https://api.genshin.dev/characters/${names[index]}/icon",
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person);
            },
          ),
        ),
        title: Text(names[index].replaceAll("-", " ").toTitleCase()),
      ),
      onTap: () {
        AlertDialog dialog = AlertDialog(
          content: SingleChildScrollView(
            child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(character.name),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Vision",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(character.vision),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Weapon",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(character.weapon),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Nation",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(character.nation),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Affiliation",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(character.affiliation),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Constellation",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(character.constellation),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          character.description,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: Icon(
                          Icons.signal_cellular_connected_no_internet_0_bar,
                        ),
                      ),
                      Center(child: Text("No internet connection."))
                    ],
                  );
                },
                future: _getCharacthers(names[index])),
          ),
        );
        dialog.build(context);
        showDialog(context: context, builder: ((context) => dialog));
      },
    );
  }
}
