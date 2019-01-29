import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/screens/jobs/job.dart';

class JobListItem extends StatelessWidget {
  const JobListItem({
    Key key,
    @required this.job,
  }) : super(key: key);

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final _date = job.createdAt;
    final _price = MkMoney(job.price).format;
    final _paid = MkMoney(job.completedPayment).format;
    final _owed = MkMoney(job.pendingPayment).format;

    return Material(
      child: InkWell(
        onTap: () => MkNavigate(context, JobPage(job: job)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${_date.day}\n",
                        style: mkFontLight(20.0, Colors.black54),
                      ),
                      TextSpan(
                        text: MkStrings.monthsShort[_date.month - 1]
                            .toUpperCase(),
                        style: mkFontLight(10.0, Colors.black).copyWith(
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      job.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kTextBaseColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      _price,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: kTextBaseColor,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    job.pendingPayment > 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_drop_up,
                                color: Colors.green.shade600,
                                size: 12.0,
                              ),
                              const SizedBox(width: 2.0),
                              Text(
                                _paid,
                                style: TextStyle(fontSize: 11.0),
                              ),
                              const SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.red.shade600,
                                size: 12.0,
                              ),
                              const SizedBox(width: 2.0),
                              Text(
                                _owed,
                                style: TextStyle(fontSize: 11.0),
                              ),
                            ],
                          )
                        : Container(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.attach_money,
                              size: 12.0,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                  ],
                ),
              ),
              Icon(
                Icons.check,
                color: job.isComplete ? kPrimaryColor : kTextBaseColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
