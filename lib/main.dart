import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ProductPage()));
}

class Product {
  String name;
  int price;
  String imageUrl; // 🔥 TAMBAHAN

  Product({required this.name, required this.price, required this.imageUrl});
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [
    Product(
      name: "Nasi Padang",
      price: 12000,
      imageUrl: "https://picsum.photos/200",
    ),
    Product(
      name: "Ayam Crispy",
      price: 20000,
      imageUrl: "https://picsum.photos/201",
    ),
    Product(
      name: "Spicy Chicken",
      price: 35000,
      imageUrl: "https://picsum.photos/202",
    ),
  ];

  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }

  void updateProduct(int index, Product product) {
    setState(() {
      products[index] = product;
    });
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void showForm({Product? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );

    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );

    TextEditingController imageController = TextEditingController(
      text: product?.imageUrl ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? "Tambah Product" : "Update Product"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Product"),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price Product"),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: "Image URL"),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text("Simpan"),
              onPressed: () {
                final newProduct = Product(
                  name: nameController.text,
                  price: int.parse(priceController.text),
                  imageUrl: imageController.text,
                );

                if (product == null) {
                  addProduct(newProduct);
                } else {
                  updateProduct(index!, newProduct);
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD App Product"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(
                products[index].imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
              title: Text(products[index].name),
              subtitle: Text("Rp ${products[index].price}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () =>
                        showForm(product: products[index], index: index),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => deleteProduct(index),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
