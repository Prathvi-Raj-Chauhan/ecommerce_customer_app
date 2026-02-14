## 🛒 E-Commerce Customer App (Flutter)

A modern full-stack e-commerce mobile application built using **Flutter** for the frontend and **Node.js + Express + MongoDB** for the backend. The app supports authentication, product browsing, cart management, secure checkout, and scalable backend APIs.
The best part -> this app supports web and android at same time by using powers given by flutter framework

---

# 🚀 Features

## Cross Platform

## Authentication

* JWT-based authentication and authorization
* Secure password reset flow

## Product & Catalog

* Product listing with categories
* Product detail page
* Search and filter functionality
* Pagination / infinite scroll support

## Cart & Orders

* Add/remove products from cart
* Quantity management
* Checkout flow
* Address management
* Order history

## Media Support

* Product image upload (Cloudinary)
* Support for PDFs and GIFs (planned)

## 🎨 UI & UX

* Clean dark theme and Light theme UI
* Custom theme system
* Modern responsive layouts
* State management using Provider

---

# 🧰 Tech Stack

## Frontend (Mobile App & Website) 

* **Flutter (Dart)**
* Provider for state management
* Dio for HTTP networking
* Google Fonts & custom themes

## Backend

* **Node.js + Express.js**
* MongoDB Atlas
* JWT authentication
* OTP verification system
* Cloudinary for media storage
* MongoDB with optimized schema design
* User, Product, Order, Cart, Address collections
* JWT user ID decoding on frontend for lightweight auth

---

# 📂 Project Structure

```
ecommerce_customer/
│
├── lib/
│   ├── models/
│   ├── services/
│   ├── components/
│   ├── theme/
│   ├── pages/
│   └── main.dart
│
├── android/
├── ios/
├── assets/
└── pubspec.yaml
```

---

# 🔐 App Signing & Release

This project uses a **dedicated keystore** for production builds.

## Build Commands

### Debug

```bash
flutter run
```

### Release APK (Testing)

```bash
flutter build apk
```

### Play Store AAB (Production)

```bash
flutter build appbundle
```

Keystore details are stored in:

```
android/key.properties
```

---

# 📦 Deployment

## Backend

* Deployed using free Node.js hosting
* MongoDB Atlas for cloud database

## Mobile App

* Google Play Store (AAB upload)
* Play App Signing enabled

---

# 🧪 Testing

* Manual UI testing
* API testing via Postman
* Release mode testing via APK

---

# 🛠️ Planned Features

* 🔔 Push notifications (Firebase)
* 💳 Payment gateway integration (Razorpay/Stripe)
* 📊 Admin dashboard (React web app)
* 🧠 AI-based product recommendations
* 🔍 Advanced filtering with debounce & URL sync
* 📱 iOS deployment support

---

# 🧠 Developer Notes

* JWT token is decoded on the frontend to extract user ID instead of headers
* Focus on scalable free-tier infrastructure
* Optimized for low-cost deployment and college-level scalability
  n---

# 📜 License

This project is for educational and personal portfolio use.

---

# 👨‍💻 Author

**PRC (Prathvi Chauhan)**
Flutter & Full Stack Developer

---

# ⭐ Tips

* Backup keystore files securely (Google Drive + GitHub private + USB)
* Never change signing key after Play Store upload
* Use environment variables for secrets in production
