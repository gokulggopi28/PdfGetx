import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/invoice_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Invoice Manager',style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.invoices.length,
        itemBuilder: (context, index) {
          final invoice = controller.invoices[index];
          return ListTile(
            title: Text('Invoice #${invoice.invoiceNumber}'),
            subtitle: Text('${invoice.customerName} - \$${invoice.totalAmount.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.download_outlined),
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
                final newInvoice = Invoice(
                  invoiceNumber: invoiceNumberController.text,
                  customerName: customerNameController.text,
                  date: DateTime.now().toString().split(' ')[0],
                  items: [
                    InvoiceItem(description: 'Service', quantity: 1, price: 100.0),
                  ],
                  totalAmount: 100.0,
                );
                
                controller.addInvoice(newInvoice);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
