import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery.dart';
import 'package:tailor_made/pages/gallery/models/image.model.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/pages/payments/models/payment.model.dart';
import 'package:tailor_made/pages/payments/payments.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class BottomRowWidget extends StatelessWidget {
  final List<JobModel> jobs;

  BottomRowWidget({
    Key key,
    @required this.jobs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ImageModel> images = [];
    final List<PaymentModel> payments = [];

    jobs.forEach((item) {
      images.addAll(item.images);
      payments.addAll(item.payments);
    });

    void onTapPayments() {
      TMNavigate(context, PaymentsPage(payments: payments.toList()));
    }

    void onTapGallery() {
      TMNavigate(context, GalleryPage(images: images.toList()));
    }

    return new Container(
      height: 120.0,
      decoration: new BoxDecoration(
        border: new Border(bottom: TMBorderSide()),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border(
                  right: TMBorderSide(),
                ),
              ),
              child: TMGridTile(
                color: Colors.redAccent,
                icon: Icons.attach_money,
                title: "Payments",
                subTitle: "26 Received",
                onPressed: onTapPayments,
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              child: TMGridTile(
                color: Colors.blueAccent,
                icon: Icons.image,
                title: "Gallery",
                subTitle: "${images.length} Photos",
                onPressed: onTapGallery,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
