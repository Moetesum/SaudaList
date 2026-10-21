import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/shopping_list.dart';

class PdfService {
  Future<Uint8List> generateListPdf(ShoppingListModel list) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('SaudaList', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text(list.title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['#', 'Product Name', 'Quantity', 'Unit', 'Status'],
            data: List.generate(list.items.length, (index) {
              final item = list.items[index];
              return [
                '${index + 1}',
                item.productName,
                '${item.quantity}',
                item.unit,
                item.isChecked ? 'Purchased' : 'Pending',
              ];
            }),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> printPdf(Uint8List pdfData) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }
}
