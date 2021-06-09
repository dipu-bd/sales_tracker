import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/models/product_report.dart';

class ProductReportView extends StatelessWidget {
  final ProductReport report;

  ProductReportView(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (report.totalItems == 0) {
      return buildEmptyMessage();
    }

    List<Widget> children = [];
    report.groups.forEach((date, salesList) {
      children.add(buildGroupHeader(date));
      children.add(Divider());
      salesList.map(buildProductItem).forEach((child) {
        children.add(child);
        children.add(SizedBox(height: 10));
      });
      children.add(SizedBox(height: 10));
    });

    children += [
      Divider(height: 1),
      SizedBox(height: 10),
      buildItemRow(
          'Total Products', '${report.items.length}', Colors.grey[700]),
      SizedBox(height: 10),
      buildItemRow('Total Quantity', '${report.totalItems}', Colors.grey[700]),
      SizedBox(height: 10),
      Divider(height: 1),
      SizedBox(height: 10),
      buildItemRow('Total Cost', report.totalCostStr, Colors.grey[700]),
    ];

    return ListView(
      children: children,
      padding: EdgeInsets.only(
        left: 15,
        top: 15.0,
        right: 15.0,
        bottom: 100.0,
      ),
    );
  }

  Widget buildEmptyMessage() {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Text(
        'No product was found',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildGroupHeader(DateTime date) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: Colors.blueGrey,
        ),
        SizedBox(width: 5),
        Text(
          DateFormat.yMMMEd().format(date),
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildProductItem(Product product) {
    return Row(
      children: [
        Text(
          '${product.quantity}'.padLeft(3, ' '),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Colors.orange[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(' × '),
        Expanded(
          child: Text(
            '${product.name} @ ${product.unitCostStr}',
            softWrap: true,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ),
        Text(' = '),
        Text(
          product.costStr.padRight(10, ' '),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
          ),
        ),
      ],
    );
  }

  Widget buildItemRow(String label, String value, [Color? valueColor]) {
    return Row(
      children: [
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[800],
          ),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
        SizedBox(width: 5),
      ],
    );
  }
}
