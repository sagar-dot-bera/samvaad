## Overview
Samvaad is a Flutter-based real-time messaging and voice-calling app focused on fast, secure communication. It supports OTP login, one-to-one chats, groups, push notifications, and peer-to-peer audio calls using WebRTC. Designed with clean architecture to enable scalable feature development and maintainable code.

## Features

OTP authentication with Firebase Authentication

Real-time chat via Cloud Firestore (typing/read receipts supportable)

Push notifications using FCM

Peer-to-peer voice calls via WebRTC (ICE/STUN)

Profiles: photo, name, bio; status (online/typing/last seen)

Groups: create, add members, chat

Basic media types (configurable)

Provider-based state management

Firestore security rules enforced

## Tech Stack

Flutter (Dart)

Firebase: Authentication, Cloud Firestore, Cloud Messaging, Cloud Storage, Cloud Functions (Node)

WebRTC (flutter_webrtc)

State management: Provider

Architecture: MVVM, Clean Architecture, SOLID, Separation of Concerns

## Project Structure (high level)

lib/

features/ (auth, chat, call, profile, groups)

common/ (widgets, utils, services)

data/ (models, repositories)

core/ (routing, di, constants)

functions/ (Firebase Cloud Functions for notifications/call signaling)

## Security & Privacy

Firestore rules restrict users to their own data and relevant chat documents.

All traffic secured via HTTPS/TLS; WebRTC secures media channels.

## Roadmap

End-to-end encryption

Video calling

Advanced media and retries/queues

Desktop/web clients
