import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Invoice Manager',
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.invoices.length,
        itemBuilder: (context, index) {
          final invoice = controller.invoices[index];
          return ListTile(
            title: Text('Invoice #${invoice['invoiceNumber']}'),
            subtitle: Text('${invoice['customerName']} - \$${invoice['totalAmount'].toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.print_rounded),
              onPressed: () => controller.downloadInvoicePDF(invoice),
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddInvoiceDialog(context),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _showAddInvoiceDialog(BuildContext context) {
    final invoiceNumberController = TextEditingController();
    final customerNameController = TextEditingController();
     final descriptionController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Invoice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: invoiceNumberController,
                decoration: InputDecoration(labelText: 'Invoice Number'),
              ),
              TextField(
                controller: customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
              ),
              
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Item Description'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Get.back(),
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
              
                final item = {
                  'description': descriptionController.text,
                  'quantity': int.parse(quantityController.text),
                  'price': double.parse(priceController.text),
                };

              
                controller.addInvoice(
                  invoiceNumber: invoiceNumberController.text,
                  customerName: customerNameController.text,
                  items: [item],
                );

                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}