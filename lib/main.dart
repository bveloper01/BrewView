import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:brewview/models/brewery_model.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const APICalling(),
    );
  }
}

class BreweryController extends GetxController {
  var breweries = <Brewery>[].obs;

  Future<void> fetchBreweries() async {
    final url = dotenv.env['API_URL'];
    final uri = Uri.parse(url!);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        breweries.value = jsonData
            .map((breweryJson) => Brewery.fromJson(breweryJson))
            .toList();
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}

class APICalling extends StatelessWidget {
  const APICalling({super.key});
  @override
  Widget build(BuildContext context) {
    final BreweryController breweryController = Get.put(BreweryController());
    breweryController.fetchBreweries();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('BrewView',
            style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      body: Obx(() {
        if (breweryController.breweries.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            itemCount: breweryController.breweries.length,
            itemBuilder: (context, index) {
              final brewery = breweryController.breweries[index];
              return Card(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                color: const Color.fromARGB(255, 247, 218, 113),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    '${brewery.name} - ${brewery.country}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    '${brewery.city}, ${brewery.state}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
