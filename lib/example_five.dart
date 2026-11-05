

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_tutorial/Model/ProductsModel.dart';

class LastExampleScreen extends StatefulWidget {
  const LastExampleScreen({super.key});

  @override
  State<LastExampleScreen> createState() => _LastExampleScreenState();
}

class _LastExampleScreenState extends State<LastExampleScreen> {
  late Future<ProductsModel> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = getProductsApi();
  }

  Future<ProductsModel> getProductsApi() async {
    final response = await http.get(
      Uri.parse('https://webhook.site/a34b45ec-42c8-48cf-a3bb-7c923340642e'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return ProductsModel.fromJson(data);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Api Course'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ProductsModel>(
              future: _productsFuture,
              builder: (context, snapshot) {
                // 1. Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Error state
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                // 3. Data state
                if (snapshot.hasData && snapshot.data?.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data!.data![index];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(snapshot.data!.data![index].shop!.name.toString()),
                            subtitle: Text(snapshot.data!.data![index].shop!.name.toString()) ,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!.data![index].shop!.image.toString()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: product.images?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      height: MediaQuery.of(context).size.height * 0.25,
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            product.images![index].url.toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Icon(
                            (snapshot.data?.data?[index].inWishlist ?? false)
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: (snapshot.data?.data?[index].inWishlist ?? true)
                                ? Colors.red
                                : null,
                          ),
                          // Space between rows of cards
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}