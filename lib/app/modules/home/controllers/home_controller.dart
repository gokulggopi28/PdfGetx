import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../data/models/invoice_model.dart';

class HomeController extends GetxController {
 
  final RxList<Invoice> invoices = <Invoice>[].obs;

  void addInvoice(Invoice invoice) {
    invoices.add(invoice);
  }

  Future<void> downloadInvoicePDF(Invoice invoice) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Invoice Number: ${invoice.invoiceNumber}'),
              pw.Text('Customer: ${invoice.customerName}'),
              pw.Text('Date: ${invoice.date}'),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  ...invoice.items.map((item) => pw.TableRow(
                    children: [
                      pw.Text(item.description),
                      pw.Text(item.quantity.toString()),
                      pw.Text('\$${item.price.toStringAsFixed(2)}'),
                      pw.Text('\$${(item.quantity * item.price).toStringAsFixed(2)}'),
                    ],
                  )).toList(),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total Amount: \$${invoice.totalAmount.toStringAsFixed(2)}', 
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
      );

      // Save PDF to device
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/invoice_${invoice.invoiceNumber}.pdf');
      await file.writeAsBytes(await pdf.save());

      await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice_${invoice.invoiceNumber}.pdf');

      Get.snackbar('Success', 'Invoice PDF downloaded successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to download invoice: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}