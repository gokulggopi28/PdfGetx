class Invoice {
  final String invoiceNumber;
  final String customerName;
  final String date;
  final List<InvoiceItem> items;
  final double totalAmount;

  Invoice({
    required this.invoiceNumber,
    required this.customerName,
    required this.date,
    required this.items,
    required this.totalAmount,
  });
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}