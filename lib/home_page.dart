import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutterapi/model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  static List<Team> teams = [];

  // get teams
  Future getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      // print(eachTeam['full_name']);
      final team =
          Team(abbreviation: eachTeam['abbreviation'], city: eachTeam['city']);
      teams.add(team);
    }

    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      body: FutureBuilder(
        future: getTeams(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // is it done loading?
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(teams[index].abbreviation),
                  subtitle: Text(teams[index].city),
                );
              }, // itemBuilder
            );
          } // if
          // show a spinner if it is still loading
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
