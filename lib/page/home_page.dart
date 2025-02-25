import 'dart:convert';

import 'package:course_crud_product/page/create_product_page.dart';
import 'package:course_crud_product/page/update_product_page%20copy.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];

  readProducts() async {
    String url = 'http://192.168.1.6/course_api_crud_product/product/read.php';
    var response = await http.get(Uri.parse(url));
    DMethod.printTitle('readProducts', response.body);
    Map responseBody = jsonDecode(response.body);
    if (responseBody['success']) {
      products = responseBody['data'];
      setState(() {});
    }
  }

  deleteproduct(Map product) async {
    bool? yes = await DInfo.dialogConfirmation(
      context,
      'Delete',
      'you sure to delete this product?',
    );
    if (yes ?? false) {
      String url =
          'http://192.168.1.6/course_api_crud_product/product/delete.php';
      var response = await http.post(Uri.parse(url), body: {
        'id': product['id'],
        'image': product['image'],
      });
      Map responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        DInfo.toastSuccess('Success Delete Product');
        readProducts();
      } else {
        DInfo.toastError('Failed Delete Product');
      }
    }
  }

  @override
  void initState() {
    readProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Home Page'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: products.isEmpty
          ? DView.empty()
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Map item = products[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    child: Row(
                      children: [
                        Image.network(
                          'http://192.168.1.6/course_api_crud_product/image/${item['image']}',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(item['description']),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return UpdateProductPage(
                                              product: item,
                                            );
                                          }),
                                        );
                                      },
                                      child: const Text('update'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  SizedBox(
                                    height: 25,
                                    child: ElevatedButton(
                                      onPressed: () => deleteproduct(item),
                                      child: const Text('delete'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
