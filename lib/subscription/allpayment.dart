import 'package:flutter/material.dart';

class AllPayment extends StatefulWidget {
  final String? payType,
      itemId,
      price,
      itemTitle,
      typeId,
      videoType,
      productPackage,
      currency;

  const AllPayment({
    Key? key,
    required this.payType,
    required this.itemId,
    required this.price,
    required this.itemTitle,
    required this.typeId,
    required this.videoType,
    required this.productPackage,
    required this.currency,
  }) : super(key: key);

  @override
  State<AllPayment> createState() => AllPaymentState();
}

class AllPaymentState extends State<AllPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item: ${widget.itemTitle}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Price: ${widget.currency} ${widget.price}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Payment Type: ${widget.payType}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processPayment,
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() {
    // Implement payment processing logic here
    // You can use the widget variables like widget.itemId, widget.price, etc.
    // For example, make an API call to process the payment

    // Sample logic for demonstration
    print('Processing payment for item ${widget.itemId}');
    print('Payment type: ${widget.payType}');
    print('Amount: ${widget.currency} ${widget.price}');
    
    // Show a success message (just as an example)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text('Your payment for ${widget.itemTitle} has been processed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
