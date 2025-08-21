const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification = functions.firestore
    .document("chats_central/{chatId}/chat/{messageId}")
    .onCreate(async (snapshot, context) => {
        try {
            const messageData = snapshot.data(); // Fixed variable name
            const chatId = context.params.chatId;

            if (!messageData) {
                console.error("Error: No message data found.");
                return null;
            }

            const recipientId = messageData.receiver; // Ensure this field exists
            if (!recipientId) {
                console.error("Error: No recipientId found.");
                return null;
            }

            const senderDoc = await admin
                .firestore()
                .collection("users")
                .doc(messageData.sender)
                .get();

            sendNotifications(recipientId, senderDoc, messageData, chatId)
                .then(() => console.log("All notifications sent!"))
                .catch((error) => console.error("Error sending notifications:", error));



        } catch (error) {
            console.error("Error sending notification:", error);
        }

        return null;
    });


exports.receiveIncomingCall = functions.firestore
    .document("call_central/{userId}/offers/{offerId}")
    .onCreate(async (snapshot, context) => {
        try {
            console.log("receive incoming call invoked");
            const offerData = snapshot.data();
            const receiverId = context.params.userId;

            if (offerData == null) {
                console.error("No offer data received");
                return null;
            }
            console.log(`caller name ${offerData.fromUser}`);
            console.log(`receiver id ${receiverId}`);

            const receiverDoc = await admin.firestore()
                .collection("users")
                .doc(receiverId)
                .get();

            const senderDoc = await admin.firestore()
                .collection("users")
                .doc(offerData.fromUser)
                .get();


            const receiverData = receiverDoc.data();
            const callerData = senderDoc.data();
            const fcmToken = receiverData && receiverData.fcmToken;
            const isAvailable = receiverData.userStatus.isOnline;

            console.log(`receiver name ${receiverData.userName}`);
            console.log(`sender name ${callerData.userName}`);
            console.log(`fcm tokken ${fcmToken}`);
            if (fcmToken == null) {
                console.error("Error getting fcmtoken");
                return null;
            }

            const offerId = context.params.offerId;

            const payload = {
                token: fcmToken,
                notification: {
                    title: `${senderData.userName} is trying to call you`,
                    body: messageData.contentType, // Fixed variable name
                },
                data: {
                    screen: "/callScreen",
                    offerFrom: `${callerData.phoneNo}`,
                    senderName: `${callerData.userName}`,
                    offerId: `${offerId}`,
                },
            };


            await admin.messaging().send(payload);
            console.log(`Notification sent to ${receiverData.userName}`);
        } catch (error) {
            console.log("Error in sending notification", error);
        }
        return null;
    });

async function sendNotification(recipientId, senderDoc, messageData, chatId) {
    try {
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(recipientId)
            .get();
        const senderData = senderDoc.data();

        const notification_settings = await admin
            .firestore()
            .collection("notification")
            .doc(recipientId)
            .get();



        let send_notification = false;

        if (notification_settings.exists) {
            const data = notification_settings.data();
            console.log("Group Notification:", data.group_notification);
            console.log("Private Notification:", data.private_notification);
            if (messageData.receiver.legth > 1) {
                if (data.group_notification == true) {
                    send_notification = true;
                }
            } else {
                if (senderData.phoneNo in data) {
                    if (data[senderData.phoneNo] == false) {
                        send_notification = true;
                    }
                }
            }
            if (messageData.receiver.legth == 1) {
                if (data.private_notification == true) {
                    send_notification = true;
                }
            }

        } else {
            send_notification = true;
        }

        if (!userDoc.exists) {
            console.error(`Error: User ${recipientId} does not exist.`);
            return null;
        } else {
            console.log(`User ${recipientId} exists.`);
        }

        const userData = userDoc.data();

        const fcmToken = userData && userData.fcmToken;



        if (!fcmToken && send_notification) {
            console.warn(
                `No FCM token found for user ${recipientId}.`
            );
            return null;
        }
        let payload = {};

        if (messageData.contentType == "text") {
            payload = {
                token: fcmToken,
                notification: {
                    title: `New message from ${senderData.userName}`,
                    body: messageData.content, // Fixed variable name
                },
                data: {
                    screen: "/chatScreen",
                    chatId: chatId,
                    senderDetail: JSON.stringify(senderData), // Send chat ID so the app can open the correct chat
                },
            };
        } else {
            payload = {
                token: fcmToken,
                notification: {
                    title: `New message from ${senderData.userName}`,
                    body: messageData.contentType, // Fixed variable name
                },
                data: {
                    screen: "/chatScreen",
                    chatId: chatId,
                    click_action: "FLUTTER_NOTIFICATION_CLICK" // Send chat ID so the app can open the correct chat
                },
            };
        }
        await admin.messaging().send(payload);
        console.log(`Notification sent to ${recipientId}`);

    } catch (error) {

    }
}

async function sendNotifications(receiverIds, senderDoc, messageData, chatId) {
    for (const receiverId of receiverIds) {
        await sendNotification(receiverId, senderDoc, messageData, chatId);
    }
}