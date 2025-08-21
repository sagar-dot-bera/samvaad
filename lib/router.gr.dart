// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i67;

import 'package:auto_route/auto_route.dart' as _i63;
import 'package:flutter/material.dart' as _i64;
import 'package:flutter_native_contact_picker/model/contact.dart' as _i72;
import 'package:samvaad/core/utils/group_chat_change_notifier_wrapper.dart'
    as _i20;
import 'package:samvaad/core/utils/single_chat_change_notifier_wrapper.dart'
    as _i51;
import 'package:samvaad/domain/entities/call.dart' as _i65;
import 'package:samvaad/domain/entities/group.dart' as _i70;
import 'package:samvaad/domain/entities/message.dart' as _i69;
import 'package:samvaad/domain/entities/participant.dart' as _i73;
import 'package:samvaad/domain/entities/rtc_request.dart' as _i66;
import 'package:samvaad/domain/entities/user.dart' as _i68;
import 'package:samvaad/main.dart' as _i22;
import 'package:samvaad/presentation/screens/call_screens/audio_call_screen.dart'
    as _i3;
import 'package:samvaad/presentation/screens/call_screens/call_log_screen.dart'
    as _i7;
import 'package:samvaad/presentation/screens/call_screens/call_main_screen.dart'
    as _i5;
import 'package:samvaad/presentation/screens/call_screens/select_contact.dart'
    as _i45;
import 'package:samvaad/presentation/screens/contact_screens/add_to_contact_screen.dart'
    as _i1;
import 'package:samvaad/presentation/screens/contact_screens/contact_host_screen.dart'
    as _i12;
import 'package:samvaad/presentation/screens/contact_screens/contact_screen.dart'
    as _i13;
import 'package:samvaad/presentation/screens/contact_screens/invite_friend_screen.dart'
    as _i24;
import 'package:samvaad/presentation/screens/demo_screen.dart' as _i16;
import 'package:samvaad/presentation/screens/main_screen.dart' as _i26;
import 'package:samvaad/presentation/screens/message_screens/add_new_message_screen.dart'
    as _i35;
import 'package:samvaad/presentation/screens/message_screens/forward_message.dart'
    as _i18;
import 'package:samvaad/presentation/screens/message_screens/group_screen/add_member_screen.dart'
    as _i34;
import 'package:samvaad/presentation/screens/message_screens/group_screen/create_new_group_screen.dart'
    as _i14;
import 'package:samvaad/presentation/screens/message_screens/group_screen/group_info_screen.dart'
    as _i21;
import 'package:samvaad/presentation/screens/message_screens/marked_message_screen.dart'
    as _i28;
import 'package:samvaad/presentation/screens/message_screens/message_host_screen.dart'
    as _i30;
import 'package:samvaad/presentation/screens/message_screens/messages_screen.dart'
    as _i31;
import 'package:samvaad/presentation/screens/message_screens/other_user_profile_screen.dart'
    as _i38;
import 'package:samvaad/presentation/screens/message_screens/send_audio.dart'
    as _i46;
import 'package:samvaad/presentation/screens/message_screens/send_contact.dart'
    as _i47;
import 'package:samvaad/presentation/screens/message_screens/send_image_preview_screen.dart'
    as _i23;
import 'package:samvaad/presentation/screens/message_screens/send_pdf_file_screen.dart'
    as _i48;
import 'package:samvaad/presentation/screens/message_screens/send_video_preview.dart'
    as _i49;
import 'package:samvaad/presentation/screens/message_screens/single_chat_screen.dart'
    as _i10;
import 'package:samvaad/presentation/screens/message_screens/user_info_screen.dart'
    as _i55;
import 'package:samvaad/presentation/screens/message_screens/view_image.dart'
    as _i61;
import 'package:samvaad/presentation/screens/message_screens/view_location.dart'
    as _i25;
import 'package:samvaad/presentation/screens/message_screens/view_pdf.dart'
    as _i62;
import 'package:samvaad/presentation/screens/profile_screens/change_number_screen.dart'
    as _i8;
import 'package:samvaad/presentation/screens/profile_screens/my_profile_screen.dart'
    as _i32;
import 'package:samvaad/presentation/screens/profile_screens/profile_main_screen.dart'
    as _i43;
import 'package:samvaad/presentation/screens/profile_screens/profile_screen.dart'
    as _i44;
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/change_wallpaper_preview.dart'
    as _i9;
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/chat_setting_screen.dart'
    as _i11;
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/faq_answer.dart'
    as _i17;
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/frequently_asked_question.dart'
    as _i19;
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/notification_screen.dart'
    as _i36;
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/pick_sound.dart'
    as _i40;
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/privacy_policy_screen.dart'
    as _i41;
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/storage_setting.dart'
    as _i53;
import 'package:samvaad/presentation/screens/profile_screens/updating_number_and_data.dart'
    as _i54;
import 'package:samvaad/presentation/screens/screen_wrappers/call_manager_wrapper.dart'
    as _i6;
import 'package:samvaad/presentation/screens/screen_wrappers/call_screen_wrapper.dart'
    as _i4;
import 'package:samvaad/presentation/screens/screen_wrappers/main_screen_wrapper.dart'
    as _i27;
import 'package:samvaad/presentation/screens/screen_wrappers/mesaage_screen_wrapper.dart'
    as _i29;
import 'package:samvaad/presentation/screens/screen_wrappers/my_profile_wrapper.dart'
    as _i33;
import 'package:samvaad/presentation/screens/screen_wrappers/phone_auth_screen_wrapper.dart'
    as _i39;
import 'package:samvaad/presentation/screens/screen_wrappers/verification_code_screen_wrapper.dart'
    as _i57;
import 'package:samvaad/presentation/screens/screen_wrappers/verification_screen_wrapper.dart'
    as _i58;
import 'package:samvaad/presentation/screens/user_onbording_screens/add_your_photo_screen.dart'
    as _i2;
import 'package:samvaad/presentation/screens/user_onbording_screens/create_profile_screen.dart'
    as _i15;
import 'package:samvaad/presentation/screens/user_onbording_screens/onbording_screen.dart'
    as _i37;
import 'package:samvaad/presentation/screens/user_onbording_screens/onbording_start_screen.dart'
    as _i52;
import 'package:samvaad/presentation/screens/user_onbording_screens/setup_name_screen.dart'
    as _i50;
import 'package:samvaad/presentation/screens/user_onbording_screens/start_screen.dart'
    as _i42;
import 'package:samvaad/presentation/screens/user_onbording_screens/verification_code_screen.dart'
    as _i56;
import 'package:samvaad/presentation/screens/user_onbording_screens/verify_phone_number.dart'
    as _i59;
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart'
    as _i71;
import 'package:samvaad/presentation/viewmodels/phone_auth_view_model.dart'
    as _i74;
import 'package:samvaad/presentation/widgets/video_player.dart' as _i60;

/// generated route for
/// [_i1.AddToContactScreen]
class AddToContactRoute extends _i63.PageRouteInfo<void> {
  const AddToContactRoute({List<_i63.PageRouteInfo>? children})
      : super(
          AddToContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddToContactRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddToContactScreen();
    },
  );
}

/// generated route for
/// [_i2.AddYourPhoto]
class AddYourPhoto extends _i63.PageRouteInfo<void> {
  const AddYourPhoto({List<_i63.PageRouteInfo>? children})
      : super(
          AddYourPhoto.name,
          initialChildren: children,
        );

  static const String name = 'AddYourPhoto';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i2.AddYourPhoto();
    },
  );
}

/// generated route for
/// [_i3.AudioCall]
class AudioCall extends _i63.PageRouteInfo<AudioCallArgs> {
  AudioCall({
    _i64.Key? key,
    required _i65.Call withUser,
    _i66.RtcRequestAndResult? offerFromCaller,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AudioCall.name,
          args: AudioCallArgs(
            key: key,
            withUser: withUser,
            offerFromCaller: offerFromCaller,
          ),
          initialChildren: children,
        );

  static const String name = 'AudioCall';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AudioCallArgs>();
      return _i3.AudioCall(
        key: args.key,
        withUser: args.withUser,
        offerFromCaller: args.offerFromCaller,
      );
    },
  );
}

class AudioCallArgs {
  const AudioCallArgs({
    this.key,
    required this.withUser,
    this.offerFromCaller,
  });

  final _i64.Key? key;

  final _i65.Call withUser;

  final _i66.RtcRequestAndResult? offerFromCaller;

  @override
  String toString() {
    return 'AudioCallArgs{key: $key, withUser: $withUser, offerFromCaller: $offerFromCaller}';
  }
}

/// generated route for
/// [_i4.AudioCallWrapperScreen]
class AudioCallWrapperRoute
    extends _i63.PageRouteInfo<AudioCallWrapperRouteArgs> {
  AudioCallWrapperRoute({
    _i64.Key? key,
    required _i65.Call withUser,
    _i66.RtcRequestAndResult? offerFromCaller,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AudioCallWrapperRoute.name,
          args: AudioCallWrapperRouteArgs(
            key: key,
            withUser: withUser,
            offerFromCaller: offerFromCaller,
          ),
          initialChildren: children,
        );

  static const String name = 'AudioCallWrapperRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AudioCallWrapperRouteArgs>();
      return _i63.WrappedRoute(
          child: _i4.AudioCallWrapperScreen(
        key: args.key,
        withUser: args.withUser,
        offerFromCaller: args.offerFromCaller,
      ));
    },
  );
}

class AudioCallWrapperRouteArgs {
  const AudioCallWrapperRouteArgs({
    this.key,
    required this.withUser,
    this.offerFromCaller,
  });

  final _i64.Key? key;

  final _i65.Call withUser;

  final _i66.RtcRequestAndResult? offerFromCaller;

  @override
  String toString() {
    return 'AudioCallWrapperRouteArgs{key: $key, withUser: $withUser, offerFromCaller: $offerFromCaller}';
  }
}

/// generated route for
/// [_i5.CallMainScreen]
class CallMainRoute extends _i63.PageRouteInfo<void> {
  const CallMainRoute({List<_i63.PageRouteInfo>? children})
      : super(
          CallMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'CallMainRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i5.CallMainScreen();
    },
  );
}

/// generated route for
/// [_i6.CallManagerWrapperScreen]
class CallManagerWrapperRoute extends _i63.PageRouteInfo<void> {
  const CallManagerWrapperRoute({List<_i63.PageRouteInfo>? children})
      : super(
          CallManagerWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'CallManagerWrapperRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return _i63.WrappedRoute(child: const _i6.CallManagerWrapperScreen());
    },
  );
}

/// generated route for
/// [_i7.CallScreen]
class CallRoute extends _i63.PageRouteInfo<void> {
  const CallRoute({List<_i63.PageRouteInfo>? children})
      : super(
          CallRoute.name,
          initialChildren: children,
        );

  static const String name = 'CallRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i7.CallScreen();
    },
  );
}

/// generated route for
/// [_i8.ChangeNumberScreen]
class ChangeNumberRoute extends _i63.PageRouteInfo<void> {
  const ChangeNumberRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ChangeNumberRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeNumberRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i8.ChangeNumberScreen();
    },
  );
}

/// generated route for
/// [_i9.ChangeWallpaperPreviewScreen]
class ChangeWallpaperPreviewRoute
    extends _i63.PageRouteInfo<ChangeWallpaperPreviewRouteArgs> {
  ChangeWallpaperPreviewRoute({
    _i64.Key? key,
    required _i67.File wallpaper,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ChangeWallpaperPreviewRoute.name,
          args: ChangeWallpaperPreviewRouteArgs(
            key: key,
            wallpaper: wallpaper,
          ),
          initialChildren: children,
        );

  static const String name = 'ChangeWallpaperPreviewRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChangeWallpaperPreviewRouteArgs>();
      return _i9.ChangeWallpaperPreviewScreen(
        key: args.key,
        wallpaper: args.wallpaper,
      );
    },
  );
}

class ChangeWallpaperPreviewRouteArgs {
  const ChangeWallpaperPreviewRouteArgs({
    this.key,
    required this.wallpaper,
  });

  final _i64.Key? key;

  final _i67.File wallpaper;

  @override
  String toString() {
    return 'ChangeWallpaperPreviewRouteArgs{key: $key, wallpaper: $wallpaper}';
  }
}

/// generated route for
/// [_i10.ChatScreen]
class ChatRoute extends _i63.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<ChatRouteArgs>(orElse: () => const ChatRouteArgs());
      return _i10.ChatScreen(key: args.key);
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i11.ChatSettingScreen]
class ChatSettingRoute extends _i63.PageRouteInfo<ChatSettingRouteArgs> {
  ChatSettingRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ChatSettingRoute.name,
          args: ChatSettingRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChatSettingRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatSettingRouteArgs>(
          orElse: () => const ChatSettingRouteArgs());
      return _i11.ChatSettingScreen(key: args.key);
    },
  );
}

class ChatSettingRouteArgs {
  const ChatSettingRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'ChatSettingRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i12.ContactHostScreen]
class ContactHostRoute extends _i63.PageRouteInfo<void> {
  const ContactHostRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ContactHostRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactHostRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i12.ContactHostScreen();
    },
  );
}

/// generated route for
/// [_i13.ContactScreen]
class ContactRoute extends _i63.PageRouteInfo<ContactRouteArgs> {
  ContactRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ContactRoute.name,
          args: ContactRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<ContactRouteArgs>(orElse: () => const ContactRouteArgs());
      return _i13.ContactScreen(key: args.key);
    },
  );
}

class ContactRouteArgs {
  const ContactRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'ContactRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i14.CreateNewGroupeScreen]
class CreateNewGroupeRoute
    extends _i63.PageRouteInfo<CreateNewGroupeRouteArgs> {
  CreateNewGroupeRoute({
    _i64.Key? key,
    required List<_i68.User> groupMemebers,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          CreateNewGroupeRoute.name,
          args: CreateNewGroupeRouteArgs(
            key: key,
            groupMemebers: groupMemebers,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateNewGroupeRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateNewGroupeRouteArgs>();
      return _i14.CreateNewGroupeScreen(
        key: args.key,
        groupMemebers: args.groupMemebers,
      );
    },
  );
}

class CreateNewGroupeRouteArgs {
  const CreateNewGroupeRouteArgs({
    this.key,
    required this.groupMemebers,
  });

  final _i64.Key? key;

  final List<_i68.User> groupMemebers;

  @override
  String toString() {
    return 'CreateNewGroupeRouteArgs{key: $key, groupMemebers: $groupMemebers}';
  }
}

/// generated route for
/// [_i15.CreateProfileScreen]
class CreateProfileRoute extends _i63.PageRouteInfo<void> {
  const CreateProfileRoute({List<_i63.PageRouteInfo>? children})
      : super(
          CreateProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateProfileRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i15.CreateProfileScreen();
    },
  );
}

/// generated route for
/// [_i16.DemoScreen]
class DemoRoute extends _i63.PageRouteInfo<void> {
  const DemoRoute({List<_i63.PageRouteInfo>? children})
      : super(
          DemoRoute.name,
          initialChildren: children,
        );

  static const String name = 'DemoRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i16.DemoScreen();
    },
  );
}

/// generated route for
/// [_i17.FAQAnswerScreen]
class FAQAnswerRoute extends _i63.PageRouteInfo<FAQAnswerRouteArgs> {
  FAQAnswerRoute({
    _i64.Key? key,
    required String question,
    required String answer,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          FAQAnswerRoute.name,
          args: FAQAnswerRouteArgs(
            key: key,
            question: question,
            answer: answer,
          ),
          initialChildren: children,
        );

  static const String name = 'FAQAnswerRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FAQAnswerRouteArgs>();
      return _i17.FAQAnswerScreen(
        key: args.key,
        question: args.question,
        answer: args.answer,
      );
    },
  );
}

class FAQAnswerRouteArgs {
  const FAQAnswerRouteArgs({
    this.key,
    required this.question,
    required this.answer,
  });

  final _i64.Key? key;

  final String question;

  final String answer;

  @override
  String toString() {
    return 'FAQAnswerRouteArgs{key: $key, question: $question, answer: $answer}';
  }
}

/// generated route for
/// [_i18.ForwardMessage]
class ForwardMessage extends _i63.PageRouteInfo<ForwardMessageArgs> {
  ForwardMessage({
    _i64.Key? key,
    required List<_i69.Message> message,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ForwardMessage.name,
          args: ForwardMessageArgs(
            key: key,
            message: message,
          ),
          initialChildren: children,
        );

  static const String name = 'ForwardMessage';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ForwardMessageArgs>();
      return _i18.ForwardMessage(
        key: args.key,
        message: args.message,
      );
    },
  );
}

class ForwardMessageArgs {
  const ForwardMessageArgs({
    this.key,
    required this.message,
  });

  final _i64.Key? key;

  final List<_i69.Message> message;

  @override
  String toString() {
    return 'ForwardMessageArgs{key: $key, message: $message}';
  }
}

/// generated route for
/// [_i19.FrequentlyAskedQuestionScreen]
class FrequentlyAskedQuestionRoute extends _i63.PageRouteInfo<void> {
  const FrequentlyAskedQuestionRoute({List<_i63.PageRouteInfo>? children})
      : super(
          FrequentlyAskedQuestionRoute.name,
          initialChildren: children,
        );

  static const String name = 'FrequentlyAskedQuestionRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i19.FrequentlyAskedQuestionScreen();
    },
  );
}

/// generated route for
/// [_i20.GroupChatChangeNotifierWrapperScreen]
class GroupChatChangeNotifierWrapperRoute
    extends _i63.PageRouteInfo<GroupChatChangeNotifierWrapperRouteArgs> {
  GroupChatChangeNotifierWrapperRoute({
    _i64.Key? key,
    required _i70.Group chatWithGroup,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          GroupChatChangeNotifierWrapperRoute.name,
          args: GroupChatChangeNotifierWrapperRouteArgs(
            key: key,
            chatWithGroup: chatWithGroup,
          ),
          initialChildren: children,
        );

  static const String name = 'GroupChatChangeNotifierWrapperRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupChatChangeNotifierWrapperRouteArgs>();
      return _i63.WrappedRoute(
          child: _i20.GroupChatChangeNotifierWrapperScreen(
        key: args.key,
        chatWithGroup: args.chatWithGroup,
      ));
    },
  );
}

class GroupChatChangeNotifierWrapperRouteArgs {
  const GroupChatChangeNotifierWrapperRouteArgs({
    this.key,
    required this.chatWithGroup,
  });

  final _i64.Key? key;

  final _i70.Group chatWithGroup;

  @override
  String toString() {
    return 'GroupChatChangeNotifierWrapperRouteArgs{key: $key, chatWithGroup: $chatWithGroup}';
  }
}

/// generated route for
/// [_i21.GroupScreen]
class GroupRoute extends _i63.PageRouteInfo<GroupRouteArgs> {
  GroupRoute({
    _i64.Key? key,
    required _i70.Group groupDetail,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          GroupRoute.name,
          args: GroupRouteArgs(
            key: key,
            groupDetail: groupDetail,
          ),
          initialChildren: children,
        );

  static const String name = 'GroupRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupRouteArgs>();
      return _i21.GroupScreen(
        key: args.key,
        groupDetail: args.groupDetail,
      );
    },
  );
}

class GroupRouteArgs {
  const GroupRouteArgs({
    this.key,
    required this.groupDetail,
  });

  final _i64.Key? key;

  final _i70.Group groupDetail;

  @override
  String toString() {
    return 'GroupRouteArgs{key: $key, groupDetail: $groupDetail}';
  }
}

/// generated route for
/// [_i22.HomePage]
class HomeRoute extends _i63.PageRouteInfo<void> {
  const HomeRoute({List<_i63.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i22.HomePage();
    },
  );
}

/// generated route for
/// [_i23.ImagePreviewScreen]
class ImagePreviewRoute extends _i63.PageRouteInfo<ImagePreviewRouteArgs> {
  ImagePreviewRoute({
    _i64.Key? key,
    required List<_i67.File> images,
    required _i71.ChatHandlerViewModel messageHandlerViewModel,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ImagePreviewRoute.name,
          args: ImagePreviewRouteArgs(
            key: key,
            images: images,
            messageHandlerViewModel: messageHandlerViewModel,
          ),
          initialChildren: children,
        );

  static const String name = 'ImagePreviewRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImagePreviewRouteArgs>();
      return _i23.ImagePreviewScreen(
        key: args.key,
        images: args.images,
        messageHandlerViewModel: args.messageHandlerViewModel,
      );
    },
  );
}

class ImagePreviewRouteArgs {
  const ImagePreviewRouteArgs({
    this.key,
    required this.images,
    required this.messageHandlerViewModel,
  });

  final _i64.Key? key;

  final List<_i67.File> images;

  final _i71.ChatHandlerViewModel messageHandlerViewModel;

  @override
  String toString() {
    return 'ImagePreviewRouteArgs{key: $key, images: $images, messageHandlerViewModel: $messageHandlerViewModel}';
  }
}

/// generated route for
/// [_i24.InviteFriendScreen]
class InviteFriendRoute extends _i63.PageRouteInfo<void> {
  const InviteFriendRoute({List<_i63.PageRouteInfo>? children})
      : super(
          InviteFriendRoute.name,
          initialChildren: children,
        );

  static const String name = 'InviteFriendRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i24.InviteFriendScreen();
    },
  );
}

/// generated route for
/// [_i25.LocationViewScreen]
class LocationViewRoute extends _i63.PageRouteInfo<LocationViewRouteArgs> {
  LocationViewRoute({
    _i64.Key? key,
    required double lat,
    required double log,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          LocationViewRoute.name,
          args: LocationViewRouteArgs(
            key: key,
            lat: lat,
            log: log,
          ),
          initialChildren: children,
        );

  static const String name = 'LocationViewRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LocationViewRouteArgs>();
      return _i25.LocationViewScreen(
        key: args.key,
        lat: args.lat,
        log: args.log,
      );
    },
  );
}

class LocationViewRouteArgs {
  const LocationViewRouteArgs({
    this.key,
    required this.lat,
    required this.log,
  });

  final _i64.Key? key;

  final double lat;

  final double log;

  @override
  String toString() {
    return 'LocationViewRouteArgs{key: $key, lat: $lat, log: $log}';
  }
}

/// generated route for
/// [_i26.MainScreen]
class MainRoute extends _i63.PageRouteInfo<void> {
  const MainRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i26.MainScreen();
    },
  );
}

/// generated route for
/// [_i27.MainScreenWrapperScreen]
class MainRouteWrapperRoute extends _i63.PageRouteInfo<void> {
  const MainRouteWrapperRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MainRouteWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRouteWrapperRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return _i63.WrappedRoute(child: const _i27.MainScreenWrapperScreen());
    },
  );
}

/// generated route for
/// [_i28.MarkedMessageScreen]
class MarkedMessageRoute extends _i63.PageRouteInfo<MarkedMessageRouteArgs> {
  MarkedMessageRoute({
    _i64.Key? key,
    required Map<String, dynamic> markedMessage,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          MarkedMessageRoute.name,
          args: MarkedMessageRouteArgs(
            key: key,
            markedMessage: markedMessage,
          ),
          initialChildren: children,
        );

  static const String name = 'MarkedMessageRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MarkedMessageRouteArgs>();
      return _i28.MarkedMessageScreen(
        key: args.key,
        markedMessage: args.markedMessage,
      );
    },
  );
}

class MarkedMessageRouteArgs {
  const MarkedMessageRouteArgs({
    this.key,
    required this.markedMessage,
  });

  final _i64.Key? key;

  final Map<String, dynamic> markedMessage;

  @override
  String toString() {
    return 'MarkedMessageRouteArgs{key: $key, markedMessage: $markedMessage}';
  }
}

/// generated route for
/// [_i29.MessageWrapperScreen]
class MessageWrapperRoute extends _i63.PageRouteInfo<void> {
  const MessageWrapperRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MessageWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessageWrapperRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return _i63.WrappedRoute(child: const _i29.MessageWrapperScreen());
    },
  );
}

/// generated route for
/// [_i30.MessagesHostScreen]
class MessagesHostRoute extends _i63.PageRouteInfo<void> {
  const MessagesHostRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MessagesHostRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessagesHostRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i30.MessagesHostScreen();
    },
  );
}

/// generated route for
/// [_i31.MessagesMainScreen]
class MessagesMainRoute extends _i63.PageRouteInfo<void> {
  const MessagesMainRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MessagesMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessagesMainRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i31.MessagesMainScreen();
    },
  );
}

/// generated route for
/// [_i32.MyProfileScreen]
class MyProfileRoute extends _i63.PageRouteInfo<MyProfileRouteArgs> {
  MyProfileRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          MyProfileRoute.name,
          args: MyProfileRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'MyProfileRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyProfileRouteArgs>(
          orElse: () => const MyProfileRouteArgs());
      return _i32.MyProfileScreen(key: args.key);
    },
  );
}

class MyProfileRouteArgs {
  const MyProfileRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'MyProfileRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i33.MyProfileWrapperScreen]
class MyProfileWrapperRoute extends _i63.PageRouteInfo<void> {
  const MyProfileWrapperRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MyProfileWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyProfileWrapperRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return _i63.WrappedRoute(child: const _i33.MyProfileWrapperScreen());
    },
  );
}

/// generated route for
/// [_i34.NewGroupScreen]
class NewGroupRoute extends _i63.PageRouteInfo<NewGroupRouteArgs> {
  NewGroupRoute({
    _i64.Key? key,
    required bool toAddMember,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          NewGroupRoute.name,
          args: NewGroupRouteArgs(
            key: key,
            toAddMember: toAddMember,
          ),
          initialChildren: children,
        );

  static const String name = 'NewGroupRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewGroupRouteArgs>();
      return _i34.NewGroupScreen(
        key: args.key,
        toAddMember: args.toAddMember,
      );
    },
  );
}

class NewGroupRouteArgs {
  const NewGroupRouteArgs({
    this.key,
    required this.toAddMember,
  });

  final _i64.Key? key;

  final bool toAddMember;

  @override
  String toString() {
    return 'NewGroupRouteArgs{key: $key, toAddMember: $toAddMember}';
  }
}

/// generated route for
/// [_i35.NewMessage]
class NewMessage extends _i63.PageRouteInfo<NewMessageArgs> {
  NewMessage({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          NewMessage.name,
          args: NewMessageArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'NewMessage';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<NewMessageArgs>(orElse: () => const NewMessageArgs());
      return _i35.NewMessage(key: args.key);
    },
  );
}

class NewMessageArgs {
  const NewMessageArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'NewMessageArgs{key: $key}';
  }
}

/// generated route for
/// [_i36.NotificationScreen]
class NotificationRoute extends _i63.PageRouteInfo<NotificationRouteArgs> {
  NotificationRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          NotificationRoute.name,
          args: NotificationRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NotificationRouteArgs>(
          orElse: () => const NotificationRouteArgs());
      return _i36.NotificationScreen(key: args.key);
    },
  );
}

class NotificationRouteArgs {
  const NotificationRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'NotificationRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i37.OnBordingScreen]
class OnBordingRoute extends _i63.PageRouteInfo<void> {
  const OnBordingRoute({List<_i63.PageRouteInfo>? children})
      : super(
          OnBordingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnBordingRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i37.OnBordingScreen();
    },
  );
}

/// generated route for
/// [_i38.OtherUserProfileScreen]
class OtherUserProfileRoute
    extends _i63.PageRouteInfo<OtherUserProfileRouteArgs> {
  OtherUserProfileRoute({
    _i64.Key? key,
    required _i68.User userDetail,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          OtherUserProfileRoute.name,
          args: OtherUserProfileRouteArgs(
            key: key,
            userDetail: userDetail,
          ),
          initialChildren: children,
        );

  static const String name = 'OtherUserProfileRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtherUserProfileRouteArgs>();
      return _i38.OtherUserProfileScreen(
        key: args.key,
        userDetail: args.userDetail,
      );
    },
  );
}

class OtherUserProfileRouteArgs {
  const OtherUserProfileRouteArgs({
    this.key,
    required this.userDetail,
  });

  final _i64.Key? key;

  final _i68.User userDetail;

  @override
  String toString() {
    return 'OtherUserProfileRouteArgs{key: $key, userDetail: $userDetail}';
  }
}

/// generated route for
/// [_i39.PhoneAuthScreenWrapper]
class PhoneAuthRouteWrapper extends _i63.PageRouteInfo<void> {
  const PhoneAuthRouteWrapper({List<_i63.PageRouteInfo>? children})
      : super(
          PhoneAuthRouteWrapper.name,
          initialChildren: children,
        );

  static const String name = 'PhoneAuthRouteWrapper';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return _i63.WrappedRoute(child: const _i39.PhoneAuthScreenWrapper());
    },
  );
}

/// generated route for
/// [_i40.PickSoundScreen]
class PickSoundRoute extends _i63.PageRouteInfo<PickSoundRouteArgs> {
  PickSoundRoute({
    _i64.Key? key,
    required _i40.AudioFileType audioFileType,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          PickSoundRoute.name,
          args: PickSoundRouteArgs(
            key: key,
            audioFileType: audioFileType,
          ),
          initialChildren: children,
        );

  static const String name = 'PickSoundRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PickSoundRouteArgs>();
      return _i40.PickSoundScreen(
        key: args.key,
        audioFileType: args.audioFileType,
      );
    },
  );
}

class PickSoundRouteArgs {
  const PickSoundRouteArgs({
    this.key,
    required this.audioFileType,
  });

  final _i64.Key? key;

  final _i40.AudioFileType audioFileType;

  @override
  String toString() {
    return 'PickSoundRouteArgs{key: $key, audioFileType: $audioFileType}';
  }
}

/// generated route for
/// [_i41.PrivacyPolicyScreen]
class PrivacyPolicyRoute extends _i63.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i63.PageRouteInfo>? children})
      : super(
          PrivacyPolicyRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i41.PrivacyPolicyScreen();
    },
  );
}

/// generated route for
/// [_i42.ProfileCreationStrartScreen]
class ProfileCreationStrartRoute extends _i63.PageRouteInfo<void> {
  const ProfileCreationStrartRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ProfileCreationStrartRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileCreationStrartRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i42.ProfileCreationStrartScreen();
    },
  );
}

/// generated route for
/// [_i43.ProfileMainScreen]
class ProfileMainRoute extends _i63.PageRouteInfo<void> {
  const ProfileMainRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ProfileMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileMainRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i43.ProfileMainScreen();
    },
  );
}

/// generated route for
/// [_i44.ProfileScreen]
class ProfileRoute extends _i63.PageRouteInfo<void> {
  const ProfileRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i44.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i45.SelectContact]
class SelectContact extends _i63.PageRouteInfo<SelectContactArgs> {
  SelectContact({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SelectContact.name,
          args: SelectContactArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SelectContact';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectContactArgs>(
          orElse: () => const SelectContactArgs());
      return _i45.SelectContact(key: args.key);
    },
  );
}

class SelectContactArgs {
  const SelectContactArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'SelectContactArgs{key: $key}';
  }
}

/// generated route for
/// [_i46.SendAudioScreen]
class SendAudioRoute extends _i63.PageRouteInfo<SendAudioRouteArgs> {
  SendAudioRoute({
    _i64.Key? key,
    required List<_i67.File> audioFiles,
    required _i71.ChatHandlerViewModel messageHandlerViewModel,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SendAudioRoute.name,
          args: SendAudioRouteArgs(
            key: key,
            audioFiles: audioFiles,
            messageHandlerViewModel: messageHandlerViewModel,
          ),
          initialChildren: children,
        );

  static const String name = 'SendAudioRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SendAudioRouteArgs>();
      return _i46.SendAudioScreen(
        key: args.key,
        audioFiles: args.audioFiles,
        messageHandlerViewModel: args.messageHandlerViewModel,
      );
    },
  );
}

class SendAudioRouteArgs {
  const SendAudioRouteArgs({
    this.key,
    required this.audioFiles,
    required this.messageHandlerViewModel,
  });

  final _i64.Key? key;

  final List<_i67.File> audioFiles;

  final _i71.ChatHandlerViewModel messageHandlerViewModel;

  @override
  String toString() {
    return 'SendAudioRouteArgs{key: $key, audioFiles: $audioFiles, messageHandlerViewModel: $messageHandlerViewModel}';
  }
}

/// generated route for
/// [_i47.SendContactScreen]
class SendContactRoute extends _i63.PageRouteInfo<SendContactRouteArgs> {
  SendContactRoute({
    _i64.Key? key,
    required List<_i72.Contact> selectedContactList,
    required _i71.ChatHandlerViewModel messageHandlerViewModel,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SendContactRoute.name,
          args: SendContactRouteArgs(
            key: key,
            selectedContactList: selectedContactList,
            messageHandlerViewModel: messageHandlerViewModel,
          ),
          initialChildren: children,
        );

  static const String name = 'SendContactRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SendContactRouteArgs>();
      return _i47.SendContactScreen(
        key: args.key,
        selectedContactList: args.selectedContactList,
        messageHandlerViewModel: args.messageHandlerViewModel,
      );
    },
  );
}

class SendContactRouteArgs {
  const SendContactRouteArgs({
    this.key,
    required this.selectedContactList,
    required this.messageHandlerViewModel,
  });

  final _i64.Key? key;

  final List<_i72.Contact> selectedContactList;

  final _i71.ChatHandlerViewModel messageHandlerViewModel;

  @override
  String toString() {
    return 'SendContactRouteArgs{key: $key, selectedContactList: $selectedContactList, messageHandlerViewModel: $messageHandlerViewModel}';
  }
}

/// generated route for
/// [_i48.SendFileScreen]
class SendFileRoute extends _i63.PageRouteInfo<SendFileRouteArgs> {
  SendFileRoute({
    _i64.Key? key,
    required List<_i67.File> files,
    required _i71.ChatHandlerViewModel messageHandlerViewModel,
    required Map<String, _i67.File> fileListWithName,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SendFileRoute.name,
          args: SendFileRouteArgs(
            key: key,
            files: files,
            messageHandlerViewModel: messageHandlerViewModel,
            fileListWithName: fileListWithName,
          ),
          initialChildren: children,
        );

  static const String name = 'SendFileRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SendFileRouteArgs>();
      return _i48.SendFileScreen(
        key: args.key,
        files: args.files,
        messageHandlerViewModel: args.messageHandlerViewModel,
        fileListWithName: args.fileListWithName,
      );
    },
  );
}

class SendFileRouteArgs {
  const SendFileRouteArgs({
    this.key,
    required this.files,
    required this.messageHandlerViewModel,
    required this.fileListWithName,
  });

  final _i64.Key? key;

  final List<_i67.File> files;

  final _i71.ChatHandlerViewModel messageHandlerViewModel;

  final Map<String, _i67.File> fileListWithName;

  @override
  String toString() {
    return 'SendFileRouteArgs{key: $key, files: $files, messageHandlerViewModel: $messageHandlerViewModel, fileListWithName: $fileListWithName}';
  }
}

/// generated route for
/// [_i49.SendVideoScreen]
class SendVideoRoute extends _i63.PageRouteInfo<SendVideoRouteArgs> {
  SendVideoRoute({
    _i64.Key? key,
    required List<_i67.File> files,
    required _i71.ChatHandlerViewModel messageChangeNotifier,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SendVideoRoute.name,
          args: SendVideoRouteArgs(
            key: key,
            files: files,
            messageChangeNotifier: messageChangeNotifier,
          ),
          initialChildren: children,
        );

  static const String name = 'SendVideoRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SendVideoRouteArgs>();
      return _i49.SendVideoScreen(
        key: args.key,
        files: args.files,
        messageChangeNotifier: args.messageChangeNotifier,
      );
    },
  );
}

class SendVideoRouteArgs {
  const SendVideoRouteArgs({
    this.key,
    required this.files,
    required this.messageChangeNotifier,
  });

  final _i64.Key? key;

  final List<_i67.File> files;

  final _i71.ChatHandlerViewModel messageChangeNotifier;

  @override
  String toString() {
    return 'SendVideoRouteArgs{key: $key, files: $files, messageChangeNotifier: $messageChangeNotifier}';
  }
}

/// generated route for
/// [_i50.SetupNameScreen]
class SetupNameRoute extends _i63.PageRouteInfo<void> {
  const SetupNameRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SetupNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetupNameRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i50.SetupNameScreen();
    },
  );
}

/// generated route for
/// [_i51.SingelChatScreenWrapperScreen]
class SingelChatRouteWrapperRoute
    extends _i63.PageRouteInfo<SingelChatRouteWrapperRouteArgs> {
  SingelChatRouteWrapperRoute({
    _i64.Key? key,
    required _i68.User userWithDetails,
    _i73.Participant? participantDetail,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SingelChatRouteWrapperRoute.name,
          args: SingelChatRouteWrapperRouteArgs(
            key: key,
            userWithDetails: userWithDetails,
            participantDetail: participantDetail,
          ),
          initialChildren: children,
        );

  static const String name = 'SingelChatRouteWrapperRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SingelChatRouteWrapperRouteArgs>();
      return _i63.WrappedRoute(
          child: _i51.SingelChatScreenWrapperScreen(
        key: args.key,
        userWithDetails: args.userWithDetails,
        participantDetail: args.participantDetail,
      ));
    },
  );
}

class SingelChatRouteWrapperRouteArgs {
  const SingelChatRouteWrapperRouteArgs({
    this.key,
    required this.userWithDetails,
    this.participantDetail,
  });

  final _i64.Key? key;

  final _i68.User userWithDetails;

  final _i73.Participant? participantDetail;

  @override
  String toString() {
    return 'SingelChatRouteWrapperRouteArgs{key: $key, userWithDetails: $userWithDetails, participantDetail: $participantDetail}';
  }
}

/// generated route for
/// [_i52.StartOnbordingScreen]
class StartOnbordingRoute extends _i63.PageRouteInfo<void> {
  const StartOnbordingRoute({List<_i63.PageRouteInfo>? children})
      : super(
          StartOnbordingRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartOnbordingRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i52.StartOnbordingScreen();
    },
  );
}

/// generated route for
/// [_i53.StorageSetting]
class StorageSetting extends _i63.PageRouteInfo<void> {
  const StorageSetting({List<_i63.PageRouteInfo>? children})
      : super(
          StorageSetting.name,
          initialChildren: children,
        );

  static const String name = 'StorageSetting';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i53.StorageSetting();
    },
  );
}

/// generated route for
/// [_i54.UpdatingNumberAndDataScreen]
class UpdatingNumberAndDataRoute extends _i63.PageRouteInfo<void> {
  const UpdatingNumberAndDataRoute({List<_i63.PageRouteInfo>? children})
      : super(
          UpdatingNumberAndDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'UpdatingNumberAndDataRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i54.UpdatingNumberAndDataScreen();
    },
  );
}

/// generated route for
/// [_i55.UserInfoScreen]
class UserInfoRoute extends _i63.PageRouteInfo<UserInfoRouteArgs> {
  UserInfoRoute({
    required _i68.User userDetail,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          UserInfoRoute.name,
          args: UserInfoRouteArgs(userDetail: userDetail),
          initialChildren: children,
        );

  static const String name = 'UserInfoRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserInfoRouteArgs>();
      return _i55.UserInfoScreen(userDetail: args.userDetail);
    },
  );
}

class UserInfoRouteArgs {
  const UserInfoRouteArgs({required this.userDetail});

  final _i68.User userDetail;

  @override
  String toString() {
    return 'UserInfoRouteArgs{userDetail: $userDetail}';
  }
}

/// generated route for
/// [_i56.VerificationCodeScreen]
class VerificationCodeRoute
    extends _i63.PageRouteInfo<VerificationCodeRouteArgs> {
  VerificationCodeRoute({
    _i64.Key? key,
    required String phoneNumber,
    bool isChangeNumber = false,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          VerificationCodeRoute.name,
          args: VerificationCodeRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
            isChangeNumber: isChangeNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'VerificationCodeRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationCodeRouteArgs>();
      return _i56.VerificationCodeScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
        isChangeNumber: args.isChangeNumber,
      );
    },
  );
}

class VerificationCodeRouteArgs {
  const VerificationCodeRouteArgs({
    this.key,
    required this.phoneNumber,
    this.isChangeNumber = false,
  });

  final _i64.Key? key;

  final String phoneNumber;

  final bool isChangeNumber;

  @override
  String toString() {
    return 'VerificationCodeRouteArgs{key: $key, phoneNumber: $phoneNumber, isChangeNumber: $isChangeNumber}';
  }
}

/// generated route for
/// [_i57.VerificationCodeWrapperScreen]
class VerificationCodeWrapperRoute
    extends _i63.PageRouteInfo<VerificationCodeWrapperRouteArgs> {
  VerificationCodeWrapperRoute({
    _i64.Key? key,
    required String phoneNumber,
    bool isChangeNumber = false,
    required _i74.PhoneAuthViewModel phoneAuthViewModel,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          VerificationCodeWrapperRoute.name,
          args: VerificationCodeWrapperRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
            isChangeNumber: isChangeNumber,
            phoneAuthViewModel: phoneAuthViewModel,
          ),
          initialChildren: children,
        );

  static const String name = 'VerificationCodeWrapperRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationCodeWrapperRouteArgs>();
      return _i63.WrappedRoute(
          child: _i57.VerificationCodeWrapperScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
        isChangeNumber: args.isChangeNumber,
        phoneAuthViewModel: args.phoneAuthViewModel,
      ));
    },
  );
}

class VerificationCodeWrapperRouteArgs {
  const VerificationCodeWrapperRouteArgs({
    this.key,
    required this.phoneNumber,
    this.isChangeNumber = false,
    required this.phoneAuthViewModel,
  });

  final _i64.Key? key;

  final String phoneNumber;

  final bool isChangeNumber;

  final _i74.PhoneAuthViewModel phoneAuthViewModel;

  @override
  String toString() {
    return 'VerificationCodeWrapperRouteArgs{key: $key, phoneNumber: $phoneNumber, isChangeNumber: $isChangeNumber, phoneAuthViewModel: $phoneAuthViewModel}';
  }
}

/// generated route for
/// [_i58.VerificationScreenWrapper]
class VerificationRouteWrapper
    extends _i63.PageRouteInfo<VerificationRouteWrapperArgs> {
  VerificationRouteWrapper({
    _i64.Key? key,
    required bool isChangeNumber,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          VerificationRouteWrapper.name,
          args: VerificationRouteWrapperArgs(
            key: key,
            isChangeNumber: isChangeNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'VerificationRouteWrapper';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationRouteWrapperArgs>();
      return _i63.WrappedRoute(
          child: _i58.VerificationScreenWrapper(
        key: args.key,
        isChangeNumber: args.isChangeNumber,
      ));
    },
  );
}

class VerificationRouteWrapperArgs {
  const VerificationRouteWrapperArgs({
    this.key,
    required this.isChangeNumber,
  });

  final _i64.Key? key;

  final bool isChangeNumber;

  @override
  String toString() {
    return 'VerificationRouteWrapperArgs{key: $key, isChangeNumber: $isChangeNumber}';
  }
}

/// generated route for
/// [_i59.VerifyPhoneNumber]
class VerifyPhoneNumber extends _i63.PageRouteInfo<VerifyPhoneNumberArgs> {
  VerifyPhoneNumber({
    _i64.Key? key,
    bool isChangeNumber = false,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          VerifyPhoneNumber.name,
          args: VerifyPhoneNumberArgs(
            key: key,
            isChangeNumber: isChangeNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyPhoneNumber';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyPhoneNumberArgs>(
          orElse: () => const VerifyPhoneNumberArgs());
      return _i59.VerifyPhoneNumber(
        key: args.key,
        isChangeNumber: args.isChangeNumber,
      );
    },
  );
}

class VerifyPhoneNumberArgs {
  const VerifyPhoneNumberArgs({
    this.key,
    this.isChangeNumber = false,
  });

  final _i64.Key? key;

  final bool isChangeNumber;

  @override
  String toString() {
    return 'VerifyPhoneNumberArgs{key: $key, isChangeNumber: $isChangeNumber}';
  }
}

/// generated route for
/// [_i60.VideoPlayerScreen]
class VideoPlayerRoute extends _i63.PageRouteInfo<VideoPlayerRouteArgs> {
  VideoPlayerRoute({
    _i64.Key? key,
    required _i67.File file,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          VideoPlayerRoute.name,
          args: VideoPlayerRouteArgs(
            key: key,
            file: file,
          ),
          initialChildren: children,
        );

  static const String name = 'VideoPlayerRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VideoPlayerRouteArgs>();
      return _i60.VideoPlayerScreen(
        key: args.key,
        file: args.file,
      );
    },
  );
}

class VideoPlayerRouteArgs {
  const VideoPlayerRouteArgs({
    this.key,
    required this.file,
  });

  final _i64.Key? key;

  final _i67.File file;

  @override
  String toString() {
    return 'VideoPlayerRouteArgs{key: $key, file: $file}';
  }
}

/// generated route for
/// [_i61.ViewImageScreen]
class ViewImageRoute extends _i63.PageRouteInfo<ViewImageRouteArgs> {
  ViewImageRoute({
    _i64.Key? key,
    required _i67.File? imageFile,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ViewImageRoute.name,
          args: ViewImageRouteArgs(
            key: key,
            imageFile: imageFile,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewImageRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewImageRouteArgs>();
      return _i61.ViewImageScreen(
        key: args.key,
        imageFile: args.imageFile,
      );
    },
  );
}

class ViewImageRouteArgs {
  const ViewImageRouteArgs({
    this.key,
    required this.imageFile,
  });

  final _i64.Key? key;

  final _i67.File? imageFile;

  @override
  String toString() {
    return 'ViewImageRouteArgs{key: $key, imageFile: $imageFile}';
  }
}

/// generated route for
/// [_i62.ViewPdfScreen]
class ViewPdfRoute extends _i63.PageRouteInfo<ViewPdfRouteArgs> {
  ViewPdfRoute({
    _i64.Key? key,
    required _i67.File pdfFile,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ViewPdfRoute.name,
          args: ViewPdfRouteArgs(
            key: key,
            pdfFile: pdfFile,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewPdfRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewPdfRouteArgs>();
      return _i62.ViewPdfScreen(
        key: args.key,
        pdfFile: args.pdfFile,
      );
    },
  );
}

class ViewPdfRouteArgs {
  const ViewPdfRouteArgs({
    this.key,
    required this.pdfFile,
  });

  final _i64.Key? key;

  final _i67.File pdfFile;

  @override
  String toString() {
    return 'ViewPdfRouteArgs{key: $key, pdfFile: $pdfFile}';
  }
}
