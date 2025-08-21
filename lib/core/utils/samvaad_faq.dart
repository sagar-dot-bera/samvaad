class SamVaadFAQsAndPrivacy {
  static Map<String, Map<String, String>> faqData = {
    "General Information": {
      "What is Samvaad?":
          "Samvaad is a modern communication app that offers real-time messaging, voice calls, and offline message storage.",
      "Is Samvaad free to use?":
          "Yes, Samvaad is free to use, with no hidden charges for core features like messaging and calling.",
      "Which devices support Samvaad?":
          "Currently, Samvaad is available on Android devices, with plans for iOS and web versions in future updates.",
      "How is Samvaad different from other messaging apps?":
          "Samvaad focuses on offline access, secure communication, and a user-friendly experience tailored for Indian users."
    },
    "Account & Authentication": {
      "How do I sign up for Samvaad?":
          "You can sign up using your mobile number, and an OTP will be sent for verification.",
      "Can I use Samvaad on multiple devices?":
          "Currently, Samvaad supports single-device login for security reasons.",
      "I didn’t receive my OTP. What should I do?":
          "Check your internet connection, ensure your number is entered correctly, or request a resend.",
      "How do I reset my password?":
          "Samvaad uses OTP-based authentication, so there’s no need for a password reset.",
      "Can I change my registered phone number?":
          "Yes, go to settings and update your phone number after verifying with a new OTP."
    },
    "Messaging & Calling": {
      "Can I send messages without an internet connection?":
          "Yes, messages are stored offline using Hive and will sync when you're back online.",
      "Does Samvaad support voice and video calls?":
          "Samvaad currently supports high-quality voice calls, with video calling planned for future updates.",
      "How do I create a group chat?":
          "Go to the chat section, tap on 'Create Group', select contacts, and set a group name.",
      "Can I delete messages after sending them?":
          "Yes, you can delete messages for yourself or for everyone within a specific time limit.",
      "How do I know if my message has been read?":
          "A double-tick with a blue indicator shows that your message has been read.",
      "How do I mute or leave a group chat?":
          "Open the group chat, go to settings, and choose 'Mute Notifications' or 'Exit Group'."
    },
    "Privacy & Security": {
      "Is my data secure on Samvaad?":
          "Yes, Samvaad ensures data security with encryption and secure authentication methods.",
      "Does Samvaad have end-to-end encryption?":
          "Yes, messages are encrypted to ensure privacy and prevent unauthorized access.",
      "Can I delete my chat history?":
          "Yes, you can clear individual chats or all chat history from settings.",
      "How do I block or report a user?":
          "Go to the user's profile and select 'Block' or 'Report' for inappropriate behavior.",
      "How do I manage my online status and privacy settings?":
          "Navigate to the privacy settings to control who can see your online status and last seen."
    },
    "Troubleshooting & Support": {
      "Why is my app not working properly?":
          "Try restarting the app, checking for updates, or clearing the cache.",
      "How do I update Samvaad to the latest version?":
          "Visit the Play Store and check for available updates.",
      "Why are my messages not sending or receiving?":
          "Ensure you have an active internet connection or check if the server is under maintenance.",
      "How can I recover deleted messages?":
          "Currently, deleted messages cannot be recovered once removed.",
      "How do I clear my app cache?":
          "Go to your device settings, navigate to 'Apps', select Samvaad, and clear cache.",
      "How do I contact customer support?":
          "You can reach out via the 'Help & Support' section in the app settings."
    },
    "Future Features & Updates": {
      "What new features can we expect in the future?":
          "Upcoming features include video calling, enhanced offline access, and a web version.",
      "When will the iOS or web version be available?":
          "An iOS and web version is planned for future releases, with no fixed timeline yet.",
      "Will Samvaad support video calling in future updates?":
          "Yes, video calling is a planned feature that will be introduced in a future update.",
      "How will I know when new updates are available?":
          "You will receive push notifications and can also check the Play Store for updates."
    }
  };

  static String privacyPolicyIntro =
      "Welcome to Samvaad! Your privacy is important to us, and we are committed to protecting your personal data. "
      "This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application. "
      "By using Samvaad, you agree to the terms of this Privacy Policy. If you do not agree, please do not use the app.";

  static Map<String, String> privacyPolicyDate = {
    "Effective Date": "[Insert Date]",
    "Last Updated": "[Insert Date]",
  };

  static Map<String, Map<String, String>> contactUs = {
    "Contact Us": {
      "Email": "[Your Support Email]",
      "Website": "[Your Website (if applicable)]"
    }
  };

  static Map<String, String> privacyPolicy = {
    "Information We Collect":
        "We collect essential information to provide a seamless experience. Personal details like phone numbers are used for authentication, while optional profile information such as name and status enhances user interaction. We do not store messages or call logs; all communications occur directly between users. With your permission, we access contacts to help you connect with friends, but we never store them. Additionally, we gather device details like model, OS version, and app version for performance optimization. Anonymous crash logs and analytics help us improve stability and user experience.",
    "How We Use Your Information":
        "Your data is used to enable core functionalities, including real-time messaging and voice calls. We enhance app performance by improving speed, stability, and security. Notifications ensure you stay updated on important events and activities. Additionally, we implement fraud prevention measures to detect and prevent spam or abuse, ensuring a safe user experience.",
    "Data Sharing & Security":
        "We prioritize your security and do not sell or trade personal data. Third-party services such as Firebase Authentication and WebRTC enable secure login and calling functionalities, while Firebase Cloud Messaging handles push notifications. We enforce robust security measures, including authentication protocols and data protection techniques, to safeguard your information.",
    "Your Privacy Choices & Controls":
        "You have full control over your data. You can edit your profile details, including name, status, and profile picture, at any time. If desired, you may permanently delete your account, which will erase all associated data. Additionally, you can manage permissions, such as revoking access to contacts, camera, and notifications, directly from your device settings.",
    "Data Retention & Deletion":
        "We do not store conversations or call logs. If you decide to delete your account, all associated data will be permanently removed, ensuring that no personal information remains stored on our servers."
  };
}
