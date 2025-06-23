# 💼 Workify

**Workify** is a full-stack freelance service marketplace app built with **Flutter** and **Firebase**, allowing users to connect, hire, and collaborate on projects in a seamless, mobile-first environment.

---

## 🚀 Features

### 🔐 User Authentication
- Secure login and registration using Firebase Authentication
- Role-based access: users can register as **clients** or **freelancers**

### 👤 Profile Setup
- Guided onboarding flow after sign-up
- Clients proceed to dashboard
- Freelancers set up their shop: skills, category, service offerings, and more

### 🛍️ Freelancer Shop
- Each freelancer has a personal shop to showcase services
- Upload work samples, define pricing packages, and display reviews

### 🔍 Service Discovery
- Clients can browse, search, and filter freelancer listings
- View detailed service descriptions and portfolios

### 💳 UPI Payment Integration
- Payments handled via **Razorpay**
- Orders only created after successful payment confirmation
- Secure and smooth checkout experience

### 📦 Order Management
- Firestore-based order system:
  - Order creation
  - Order tracking
  - Delivery & work submission
- Freelancer & client each have their own order views

### 💬 Real-time Chat
- Built-in chat system using Firestore
- One-on-one messaging between clients and freelancers
- Supports file sharing (images, documents)

### 📝 Reviews & Ratings
- Clients can rate and review freelancers after order completion
- Reviews shown on freelancer shop profiles

---

## 🔧 Tech Stack

| Tech         | Description                        |
|--------------|------------------------------------|
| Flutter      | Cross-platform UI framework        |
| Firebase     | Backend services (Auth, Firestore, Storage, FCM) |
| Razorpay     | UPI payment integration            |
| UUID         | Unique order & chat ID generation  |

---

## 📁 Firestore Collections

```plaintext
users/
  └── {userId}
       ├── freelancer: true/false
       ├── profile info
       ├── myOrders/

shops/
  └── {userId}  // same as freelancer UID
       ├── shop info
       ├── services/
       ├── receivedOrders/
       ├── reviews/

orders/
  └── {orderId}
       ├── freelancerId, clientId, serviceId
       ├── status, timestamps, payment info

chats/
  └── {chatId}
       ├── participants
       ├── lastMessage
       ├── messages/
```
🚧 Upcoming Features
Push notifications via FCM

Admin dashboard

Subscription plans for premium freelancers

Wallet & earnings dashboard

In-app calling

📦 Getting Started
Prerequisites
Flutter SDK

Firebase Project

Razorpay account (for test API key)

Clone & Run
bash
Copy code
git clone https://github.com/yourusername/workify.git
cd workify
flutter pub get
flutter run
Configure Firebase
Add your Firebase config (google-services.json / GoogleService-Info.plist)

Enable Firebase Auth, Firestore, and Storage

Update Firestore rules for authenticated access

🙌 Contributing
Feel free to fork the repo and submit a pull request. For major changes, please open an issue first to discuss what you'd like to change
