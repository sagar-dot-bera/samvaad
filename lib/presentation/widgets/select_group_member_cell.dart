import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/widgets/app_contact_cell_status.dart';

class SelectGroupMemberCell extends StatelessWidget {
  User userDetail;
  bool isSelected;
  SelectGroupMemberCell(
      {super.key, required this.userDetail, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: ContactWithStatusCell(user: userDetail)),
        isSelected
            ? Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.fromLTRB(0.0, 30.0, 10.0, 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Icon(FeatherIcons.check,
                    color: Theme.of(context).colorScheme.onPrimary),
              )
            : SizedBox()
      ],
    );
  }
}
