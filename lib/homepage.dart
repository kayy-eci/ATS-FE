import 'package:flutter/material.dart';
import 'package:frontendats/addproduct.dart';
import 'package:frontendats/editproduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];

  Future<void> getProduct() async {
    final data = await http.get(
      Uri.parse("https://fakestoreapi.com/products")
    );

    if (data.statusCode == 200) {
      setState(() {
        products = jsonDecode(data.body);
      });
    } else {
      print("data gagal di ambil");
    }
  }

  Future<void> deleteProduct(int id) async {
  final data = await http.delete(
    Uri.parse('https://fakestoreapi.com/products/$id'),
  );

  if (data.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produk Berhasil Dihapus: ${data.statusCode}')),
    );

    setState(() {
      products.removeWhere((product) => product['id'] == id);
    });
  } else {
    print('Gagal menghapus produk: ${data.statusCode}');
  }
}

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index){
          final itemProduct = products[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => EditProductPage(product: itemProduct),
                ),
              );
            },
            child: ListTile(
              leading: Image.network(itemProduct["image"]),
              title: Text(itemProduct["title"]),
              subtitle: Text(itemProduct["price"].toString()),
              trailing: IconButton(onPressed: (){
                deleteProduct(itemProduct['id']);
              }, 
              icon: Icon(Icons.delete)
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => AddProductPage())
        );
      },
      child: Icon(Icons.add),
      ),
    );
  }
}