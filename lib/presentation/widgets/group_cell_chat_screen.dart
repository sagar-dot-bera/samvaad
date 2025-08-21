import 'package:flutter/material.dart';
import 'package:samvaad/domain/entities/group.dart';
import 'package:samvaad/presentation/widgets/group_cell.dart';

class GroupCellChatScreen extends StatelessWidget {
  Group groupDetail;
  GroupCellChatScreen({super.key, required this.groupDetail});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 4.0),
        child: GroupCell(
          groupDetail: groupDetail,
          boldText: false,
          priyaChe: false,
          isSelected: false,
        ));
  }
}
