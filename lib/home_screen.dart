import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EcommerceScreen(),
    );
  }
}

class EcommerceScreen extends StatefulWidget {
  @override
  _EcommerceScreenState createState() => _EcommerceScreenState();
}

class _EcommerceScreenState extends State<EcommerceScreen> {
  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) {
      return 1; // For smaller screens, use 2 columns
    } else if (screenWidth < 600) {
      return 2; // For larger screens, use 3 columns
    } else {
      return 3;
    }
  }

  // Sample product data (you can replace this with your own product models)
  final List<Product> products = [
    Product(
      name: "Cap 1",
      description: "Stylish cap with logo",
      imageUrl: "assets/cap1.jpg",
    ),
    Product(
      name: "Cap 2",
      description: "Stylish cap with logo",
      imageUrl: "assets/cap1.jpg",
    ),
    Product(
      name: "Cap 3",
      description: "Stylish cap with logo",
      imageUrl: "assets/cap1.jpg",
    ),
    Product(
      name: "Eyeglasses 1",
      description: "Classic black eyeglasses",
      imageUrl: "assets/eyeglasses1.jpg",
    ),
    Product(
      name: "Eyeglasses 2",
      description: "Classic black eyeglasses",
      imageUrl: "assets/eyeglasses1.jpg",
    ),
    Product(
      name: "Eyeglasses 3",
      description: "Classic black eyeglasses",
      imageUrl: "assets/eyeglasses1.jpg",
    ),
    // Add more products here
  ];

  // Function to add a new product to the list
  void _addNewProduct(Product newProduct) {
    setState(() {
      products.add(newProduct);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("E-commerce App"),
        actions: <Widget>[
          Tooltip(
            message: "Add New Product",
            child: TextButton(
              onPressed: () {
                _showAddProductDialog(context);
              },
              child: Text(
                "ADD PRODUCT",
                style: TextStyle(
                  color: Colors.white, // Change text color as needed
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Slider (you can replace this with a proper slider widget)
            Container(
              height: 200,
              color: Colors.grey,
              alignment: Alignment.center,
              child: Text("Slider Placeholder"),
            ),
            // Product grid view
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _calculateCrossAxisCount(context),
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Product"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                // You can add an image upload widget here
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Create a new product and add it to the list
                final newProduct = Product(
                  name: nameController.text,
                  description: descriptionController.text,
                  imageUrl: "assets/placeholder.jpg", // Set a placeholder image URL
                );
                _addNewProduct(newProduct);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Save"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

class Product {
  final String name;
  final String description;
  final String imageUrl;

  Product({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class ProductCard extends StatelessWidget {
  final Product product;

  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) {
      return 1; // For smaller screens, use 2 columns
    } else if (screenWidth < 600) {
      return 2; // For larger screens, use 3 columns
    } else {
      return 3;
    }
  }

  ProductCard({required this.product});

  void _openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      // Handle the case where no camera is available
      return;
    }

    final selectedCamera = cameras.first; // You can choose a specific camera if needed

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: selectedCamera),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Product image
            Container(
              constraints: BoxConstraints(maxHeight: 150), // Maximum height for the product image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(product.imageUrl),
                  fit: BoxFit.contain, // Adjust the fit as needed
                ),
              ),
            ),
            // Product title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _calculateFontSize(context),
                ),
              ),
            ),
            // Product description (2 lines)
            if (_calculateCrossAxisCount(context) > 1) // Display description for wider screens
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            // Buttons (Add to cart, Virtual try on, Buy now)
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              buttonMinWidth: 100, // Adjust the minimum button width as needed
              buttonHeight: 10,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Add to cart logic
                  },
                  child: Text("Add to Cart"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _openCamera(context);
                  },
                  child: Text("Virtual Try On"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Buy now logic
                  },
                  child: Text("Buy Now"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) {
      return 12; // For smaller screens, use a smaller font size
    } else if (screenWidth < 600) {
      return 14; // For larger screens, use a larger font size
    } else {
      return 16;
    }
  }
}

