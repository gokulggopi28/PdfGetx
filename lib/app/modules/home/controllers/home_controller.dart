import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class HomeController extends GetxController {
 
 final RxList<Map<String, dynamic>> invoices = <Map<String, dynamic>>[].obs;

  void addInvoice({
    required String invoiceNumber,
    required String customerName,
    List<Map<String, dynamic>>? items,
  }) {
 double totalAmount = items?.fold<double>(0.0, (sum, item) {
  final quantity = item['quantity'] is int ? item['quantity'] as int : 0;
  final price = item['price'] is double ? item['price'] as double : 0.0;
  return sum + (quantity * price);
}) ?? 0.0;
 final invoice = {
      'invoiceNumber': invoiceNumber,
      'customerName': customerName,
      'date': DateTime.now().toString().split(' ')[0],
      'items': items ?? [],
      'totalAmount': totalAmount,
    };

    invoices.add(invoice);
  }

  Future<void> downloadInvoicePDF(Map<String, dynamic> invoice) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Invoice Number: ${invoice['invoiceNumber']}'),
              pw.Text('Customer: ${invoice['customerName']}'),
              pw.Text('Date: ${invoice['date']}'),
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
                  ...List.generate(
                    (invoice['items'] as List).length, 
                    (index) {
                      final item = invoice['items'][index];
                      return pw.TableRow(
                        children: [
                          pw.Text(item['description']),
                          pw.Text(item['quantity'].toString()),
                          pw.Text('\$${item['price'].toStringAsFixed(2)}'),
                          pw.Text('\$${(item['quantity'] * item['price']).toStringAsFixed(2)}'),
                        ],
                      );
                    }
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total Amount: \$${invoice['totalAmount'].toStringAsFixed(2)}', 
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
      );

      // Save PDF to device
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/invoice_${invoice['invoiceNumber']}.pdf');
      await file.writeAsBytes(await pdf.save());

      
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice_${invoice['invoiceNumber']}.pdf');

      Get.snackbar('Success', 'Invoice PDF downloaded successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to download invoice: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}