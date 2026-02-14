## 🛒 E-Commerce Customer App (Flutter)

A modern full-stack e-commerce application built using **Flutter** for the frontend and **Node.js + Express + MongoDB** for the backend. The app supports authentication, product browsing, cart management, secure checkout, and scalable backend APIs.
This project supports **Android and Web from a single Flutter codebase**.

# Mobile UI
<img width="1920" height="1080" alt="Purple Pink Gradient Mobile Application Presentation" src="https://github.com/user-attachments/assets/1a92f396-7584-4718-ba0e-2df78e0c1ff2" />

# Web UI
<img width="1920" height="1080" alt="Screenshot (173)" src="https://github.com/user-attachments/assets/cc0afb44-36c9-48a1-9863-cd8cdec2ea67" />
<img width="1920" height="1080" alt="Screenshot (174)" src="https://github.com/user-attachments/assets/bd86bf96-d6d0-49d5-a058-e80ede82a38f" />
<img width="1920" height="1080" alt="Screenshot (177)" src="https://github.com/user-attachments/assets/0c664f70-cb78-4a4e-a618-86c2a81bf18f" />
<img width="1920" height="1080" alt="Screenshot (178)" src="https://github.com/user-attachments/assets/509189e4-e4f8-4b47-9177-b447a2b9a6c7" />



---

# 🚀 Features

## Cross Platform

* Single codebase for Android and Web using Flutter

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

## UI & UX

* Clean dark and light theme UI
* Custom theme system
* Modern responsive layouts
* State management using Provider
* Uses modern skeleton loading screens
  ![WhatsApp Image 2026-02-14 at 12 31 59 PM](https://github.com/user-attachments/assets/32289fed-659e-4e72-a275-12cf54f7c221)


---

# 🧰 Tech Stack

## Frontend (Mobile App & Web)

* Flutter (Dart)
* Provider for state management
* Dio for HTTP networking
* Google Fonts and custom themes

## Backend

* Node.js + Express.js
* MongoDB Atlas
* JWT authentication
* OTP verification system
* Cloudinary for media storage
* Redis for caching (homepage products)
* MongoDB atomic transactions for order placement

## Infrastructure (Free Tier)

* MongoDB Atlas (M0 Cluster)
* Redis Cloud (30MB Free)
* Cloudinary Free Tier

---

# 📦 Deployment

## Backend

* Deployed using free Node.js hosting
* MongoDB Atlas as primary database

## Mobile & Web App

* Play App Signing enabled for Android
* Web deployed via Flutter Web build

## Admin Panel

* Web-based admin dashboard built in Flutter
* Manages products, orders, users, and content
  n---

# 🔔 Notifications

* Push notifications implemented for user events and order updates,
* Uses FCM tokens and Firebase Cloud Messaging module for node js

---

# 🧪 Testing

* Manual UI testing
* API testing via Postman
* Release mode testing via APK

---

# 🛠️ Planned Features

* Payment gateway integration (Razorpay/Stripe)
* Analytics dashboard for admin
* AI-based product recommendations

---

# 🧠 Developer Notes

* JWT token is not decoded on the frontend to extract user ID so it is safer
* Redis caching used for homepage product performance
* MongoDB atomicity ensured for order placement
* Focus on scalable free-tier infrastructure and cost efficiency

---

# 📜 License

This project is for educational and personal portfolio use.

---

# 👨‍💻 Author

Prathvi Raj Chauhan
Flutter & Full Stack Developer
