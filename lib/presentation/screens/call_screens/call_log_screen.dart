import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/utils/menu.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/viewmodels/call_manager_view_model.dart';
import 'package:samvaad/presentation/widgets/animations.dart';
import 'package:samvaad/presentation/widgets/app_call_cell.dart';
import 'package:samvaad/presentation/widgets/app_rounded_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_text_field.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  void refresh() {
    setState(() {});
  }

  ValueNotifier<bool> isSearchOn = ValueNotifier<bool>(false);
  ValueNotifier<List<User>> searchList =
      ValueNotifier<List<User>>(List.empty());
  bool noResutlFound = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: ValueListenableBuilder(
              valueListenable: isSearchOn,
              builder: (context, value, child) {
                if (value) {
                  return AppTextField(
                    hint: "Search",
                    leadingIcon: Icon(Remix.user_2_line),
                    validate: (value) {},
                    control: textEditingController,
                    keybordType: TextInputType.text,
                    optionalPadding: SizeOf.intance.getWidth(context, 0.0001),
                    sufficIcon: IconButton(
                        onPressed: () {},
                        icon: IconButton(
                            onPressed: () {
                              isSearchOn.value = !isSearchOn.value;
                            },
                            icon: Icon(Remix.close_line))),
                    onTextChange: (p0) {
                      if (p0 != null && p0.isNotEmpty) {
                        Provider.of<CallManagerViewModel>(context,
                                listen: false)
                            .searchCallLog(p0);
                        if (searchList.value.isEmpty) {
                          noResutlFound = true;
                        } else {
                          noResutlFound = false;
                        }
                      } else if (p0 == null || p0.isEmpty) {
                        Provider.of<CallManagerViewModel>(context,
                                listen: false)
                            .clearFilterList();
                      }
                    },
                  );
                } else {
                  return HeadlineMedium(text: "Call log");
                }
              }),
          actions: [
            ValueListenableBuilder(
                valueListenable: isSearchOn,
                builder: (context, value, child) {
                  if (!value) {
                    return IconButton(
                        onPressed: () {
                          isSearchOn.value = !isSearchOn.value;
                        },
                        icon: Icon(Remix.search_2_line));
                  } else {
                    return SizedBox();
                  }
                }),
            Consumer<CallManagerViewModel>(
                builder: (context, callManagerViewModel, child) {
              if (callManagerViewModel.selectedLogs.isEmpty) {
                return PopupMenuButton(onSelected: (value) {
                  callManagerViewModel.clearAll();
                }, itemBuilder: (context) {
                  return Menu.intance.getPopUpList(Menu.intance.callLogMenu);
                });
              } else {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        callManagerViewModel
                            .deleteCallLog(callManagerViewModel.selectedLogs);
                      },
                      icon: Icon(Remix.delete_bin_line),
                    ),
                    SizedBox(
                      width: SizeOf.intance.getWidth(context, 0.02),
                    ),
                    Text(
                      callManagerViewModel.selectedLogs.length.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(
                      width: SizeOf.intance.getWidth(context, 0.05),
                    )
                  ],
                );
              }
            })
          ]),
      body: Column(
        children: [
          Expanded(
              child: CallLogListView(
            onRefresh: refresh,
          ))
        ],
      ),
      floatingActionButton: AppRoundedButton(
        buttonIcon: Icon(
          FeatherIcons.phoneCall,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onClikc: () {
          context.router.push(SelectContact());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class CallLogListView extends StatefulWidget {
  final Function() onRefresh;
  const CallLogListView({super.key, required this.onRefresh});

  @override
  State<CallLogListView> createState() => _CallLogListViewState();
}

class _CallLogListViewState extends State<CallLogListView> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<CallManagerViewModel>(context, listen: false)
        .getCallLogs()
        .whenComplete(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallManagerViewModel>(builder: (context, value, child) {
      if (isLoading) {
        return ProfileCellShimmerList();
      } else if (value.callLogs.isEmpty) {
        return Center(child: LoadingAnimationOne());
      } else {
        return ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (value.isSelectionModeOn) {
                    value.modifySelected(
                        value.callLogs[index].callDetail["timeStamp"]);
                  }
                },
                onLongPress: () {
                  value.modifySelected(
                      value.callLogs[index].callDetail["timeStamp"]);
                },
                child: CallLogCell(
                  isSelected: value.selectedLogs
                      .contains(value.callLogs[index].callDetail["timeStamp"]),
                  callLog: value.filteredList.isEmpty
                      ? value.callLogs[index]
                      : value.filteredList[index],
                  onRefresh: widget.onRefresh,
                ),
              );
            },
            itemCount: value.filteredList.isEmpty
                ? value.callLogs.length
                : value.filteredList.length);
      }
    });
  }
}

class LoadingAnimationOne extends StatelessWidget {
  const LoadingAnimationOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("No Data Found");
  }
}
