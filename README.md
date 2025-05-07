# ✈️ Away – Travel Video Parser App

**Away** is a cross-platform Flutter app that transforms destination-based videos (e.g., Reels, TikToks, YouTube Shorts) into interactive location cards. Users can upload travel content and browse a community-generated feed mapped by real video content.

---

## 📱 Features

- 🌍 **Interactive Map**  
  Automatically pins new destinations based on parsed video metadata (captions, audio, etc.).

- 🎞 **Video-to-Location Parser**  
  Uses NLP to extract place names from video captions or audio and geocodes them using the Google Maps API.

- 🔐 **Authentication**  
  Includes email/password sign-in and plans for Google/Apple login.

- 🗂 **User Tabs**  
  Navigate seamlessly across:  
  `Home`, `Import`, `Map`, `Chat`, and `Profile`.

- 🧠 **ML/NLP Parsing Stack**  
  Built using `spaCy`, `instaloader`, and optional `transformer` models for robust place-name detection.

---

## 🧩 Tech Stack

| Layer           | Tool / Language     |
|----------------|---------------------|
| Frontend       | Flutter + Dart      |
| UI Design      | Figma               |
| Backend (WIP)  | Python (parsing)    |
| NLP Parsing    | spaCy               |
| Maps & Geocoding | Google Maps API   |
| Auth           | Firebase Auth (planned) |
| Video Input    | Link-based (Instagram, YouTube, TikTok) |

---

## 📐 Figma Design

Explore the UI prototype:  
👉 [Figma: Away App](https://www.figma.com/design/n4urGzItW82zaoFxVd1GtF/Away.?node-id=0-1&p=f&t=PyaJDIrSvO5xF4cs-0)

---

## 📊 Pitch Deck

Learn more about the product vision and market opportunity:  
👉 [Canva Pitch Deck](https://www.canva.com/design/DAGmmKYGHks/tdF4P7moTcYmGu08TMqHOw/edit?utm_content=DAGmmKYGHks&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

---

## 🚀 Getting Started

1. **Clone the repo**
   ```bash

     ## Get started:
  install flutter - check with `flutter doctor` to make sure everything is installed correctly
  
  ### To run:
  `flutter run`
  
  in vscode terminal: 
  `open -a Simulator` 
  while still running do:
  `flutter devices` and then
  `flutter run -d <device_id>`

