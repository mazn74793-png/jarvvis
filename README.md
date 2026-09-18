<div align="center">

<h1>🤖 J.A.R.V.I.S — Windows AI Assistant</h1>

<p><strong>A voice-enabled Windows desktop assistant powered by Gemini Live API or local LM Studio</strong></p>

![Python](https://img.shields.io/badge/Python-3.10%2B-blue?style=for-the-badge&logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![Gemini](https://img.shields.io/badge/Powered%20by-Gemini%202.5%20Flash-orange?style=for-the-badge&logo=google&logoColor=white)

</div>

---

## 📋 Table of Contents

- [About the Project](#-about-the-project)
- [Features](#-features)
- [Architecture](#-architecture)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Supported Commands](#-supported-commands)
- [Local Mode (LM Studio)](#-local-mode-lm-studio)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)

---

## 🎯 About the Project

JARVIS is a real-time voice AI assistant developed for the Windows desktop environment. It is built on the Google Gemini 2.5 Flash Live API and can operate in both **cloud (Gemini)** and **fully offline local (LM Studio)** modes.

It communicates with the user via voice, processes voice commands in real time, and executes real actions on Windows through 16+ integrated tools.

---

## ✨ Features

### Voice and Speech
- 🎙️ **Real-time audio streaming** — 16 kHz input, 24 kHz output via PyAudio
- 🔊 **Natural voice responses** — Gemini Native Audio or Windows SAPI TTS
- ✍️ **Text mode** — Written command support alongside voice
- 🔇 **Pause / Resume** — Instant pause without dropping the session

### System Integration
- 🖥️ **Application management** — Open any Windows application by voice
- 📊 **System info** — CPU, RAM, disk, battery, time, date, network status
- 💻 **PowerShell** — Run terminal commands via voice
- 👁️ **Screen analysis** — Capture and analyze the active window with AI (Gemini Vision or LM Studio Vision)

### Productivity
- 📅 **Calendar** — Outlook or local JSON calendar; read, add, and delete events
- ⏰ **Reminders** — Outlook Tasks or local JSON; create and list reminders
- 🧠 **Persistent memory** — Save and delete user-specific information in JSON

### Communication and Media
- 💬 **WhatsApp** — Compose and auto-send messages via Desktop or Web; import VCF contacts
- 🌦️ **Weather** — Real-time weather summary (OpenWeatherMap)
- 🎵 **Media playback** — YouTube, Spotify Desktop, and Apple Music Web integration
- 🌐 **Browser control** — Open URLs, Google search, play YouTube videos
- 📈 **YouTube Analytics** — Channel statistics and video performance reports

### Dual Backend Support
- ☁️ **Gemini mode** — Google Gemini 2.5 Flash Live API
- 🏠 **Local mode** — Fully offline operation with LM Studio (OpenAI-compatible); Whisper or Google STT

---

## 🏗️ Architecture

```
jarvis/
├── main.py                  ← Gemini Live session manager (JarvisLive)
├── ui.py                    ← Tkinter-based desktop UI (JarvisUI)
├── app_config.py            ← Configuration read/write
├── core/
│   ├── lmstudio_runtime.py  ← Local mode engine (JarvisLocal)
│   └── prompt.txt           ← AI system prompt
├── actions/                 ← Tool modules
│   └── ...
├── memory/                  ← Persistent memory
└── config/                  ← API keys
```

### Data Flow — Gemini Mode

```
Microphone → PyAudio → Gemini Live API
                             ↓
                      Tool Call Detection
                             ↓
                      actions/* modules
                             ↓
                      Result → Gemini → Audio Output → Speaker
```

### Data Flow — Local Mode

```
Microphone → SpeechRecognition (Whisper/Google STT) → Text
                                                          ↓
                                                   LM Studio API
                                                          ↓
                                                  Tool Call Detection
                                                          ↓
                                                  actions/* modules
                                                          ↓
                                                  Text → Windows SAPI TTS → Speaker
```

---

## 📦 Requirements

| Requirement | Details |
|-------------|---------|
| **Python** | 3.10 or higher |
| **Operating System** | Windows 10 / 11 |
| **Gemini API Key** | Free from [Google AI Studio](https://aistudio.google.com/apikey) |
| **Microphone** | Any USB or built-in microphone |
| **YouTube API** | Optional — for channel statistics |
| **LM Studio** | Optional — for local offline mode |

### Python Dependencies

```
google-genai
SpeechRecognition
pyaudio
psutil
Pillow
requests
pyautogui
pyttsx3
pywin32
openai-whisper  (optional, for local STT)
```

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/bnsware/jarvis.git
cd jarvis
```

### 2. Automatic Setup (Recommended)

```batch
setup.bat
```

This script performs the following steps in order:
- Checks for Python installation
- Creates a `venv` virtual environment
- Installs required fonts on Windows
- Installs packages from `requirements.txt`
- Creates `config/api_keys.json` from the template

### 3. Manual Setup

```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
copy config\api_keys.example.json config\api_keys.json
```

> **Note:** If you get an error installing PyAudio:
> ```bash
> pip install pipwin
> pipwin install pyaudio
> ```

---

## ⚙️ Configuration

Edit the `config/api_keys.json` file:

```json
{
  "gemini_api_key": "AIza...",
  "voice": "Charon",
  "youtube_api_key": "",
  "youtube_channel_handle": "@yourchannel",
  "backend": "gemini",
  "lmstudio_base_url": "http://127.0.0.1:1234/v1",
  "lmstudio_model": "local-model",
  "lmstudio_api_key": "lm-studio",
  "stt_engine": "whisper",
  "stt_language": "en-US"
}
```

| Field | Description | Required |
|-------|-------------|----------|
| `gemini_api_key` | Google Gemini API key | Yes in Gemini mode |
| `voice` | Voice tone: `Charon`, `Aoede`, `Fenrir`, `Kore`, `Puck` | No |
| `youtube_api_key` | YouTube Data API v3 key | For channel reports |
| `youtube_channel_handle` | Handle in `@yourchannel` format | For channel reports |
| `backend` | `gemini` or `lmstudio` | No (default: gemini) |
| `lmstudio_base_url` | LM Studio server address | Yes in local mode |
| `lmstudio_model` | Local model name to use | Yes in local mode |
| `stt_engine` | `whisper` or `google` | In local mode |
| `stt_language` | STT language code | In local mode |

---

## 🎮 Usage

### Launching

```batch
start.bat
```

or manually:

```bash
venv\Scripts\activate
python main.py
```

### Interface

When JARVIS opens, a modern desktop window appears:

- **Status indicator** — `LISTENING`, `THINKING`, `SPEAKING`, `ERROR`
- **Log panel** — Real-time conversation stream
- **Text box** — Enter written commands alongside voice
- **Pause button** — Silences the assistant without dropping the session
- **System panel** — CPU, RAM, battery, and weather widgets

---

## 🗣️ Supported Commands

### System and Applications

```
"Open Spotify"
"Launch VS Code"
"What's the battery status?"
"How much RAM is being used?"
"What time is it?"
"List files on the desktop"
```

### Calendar

```
"What's on my calendar today?"
"What's my schedule tomorrow?"
"What's my next meeting?"
"What's on my calendar for the next 30 days?"
"Add a dentist appointment tomorrow at 2 PM"
"Add a meeting Monday from 10:00 to 11:00"
"Delete the meeting from my calendar"
```

### Reminders

```
"What are my reminders for today?"
"Show my upcoming reminders"
"Remind me about the dentist tomorrow morning at 9"
"Remind me to buy milk this evening"
```

### Weather and Browser

```
"What's the weather in New York?"
"Search Google for learn Python"
"Open The Weeknd Blinding Lights on YouTube"
"Open github.com"
```

### Media

```
"Play The Weeknd Blinding Lights on Spotify"
"Open Adele Hello on Apple Music"
"Play lofi beats on YouTube"
```

### WhatsApp

```
"Send a goodnight message to Mom on WhatsApp"
"Prepare a WhatsApp message to John: let's meet tomorrow"
```

### Screen Analysis

```
"What's on the screen?"
"Read this error"
"Analyze this window"
"What does it say here?"
```

### YouTube Analytics

```
"How are my YouTube stats?"
"Analyze my recent videos"
"Summarize my channel growth"
```

### Memory

```
"My name is Alex"
"My project is a Python application"
"Remove the Claude limit note from your memory"
"Forget this"
```

---

## 🏠 Local Mode (LM Studio)

To run entirely locally without an internet connection:

**1. Download LM Studio and load a model:**
Download from [lmstudio.ai](https://lmstudio.ai), select a model, and start the server.

**2. Update `config/api_keys.json`:**
```json
{
  "backend": "lmstudio",
  "lmstudio_base_url": "http://127.0.0.1:1234/v1",
  "lmstudio_model": "lmstudio-community/mistral-7b-instruct",
  "stt_engine": "whisper"
}
```

**3. For screen analysis, add a vision model:**
```json
{
  "lmstudio_vision_model": "xtuner/llava-llama-3-8b-v1_1-gguf"
}
```

**What changes in local mode:**
- Audio input → Whisper (local) or Google STT
- Audio output → Windows SAPI TTS (system voice)
- AI engine → LM Studio OpenAI-compatible API
- All tools work the same way

---

## 📁 Project Structure

```
jarvis/
├── main.py                  ← Entry point and Gemini Live engine
├── ui.py                    ← Desktop UI (Tkinter)
├── app_config.py            ← Configuration manager
├── requirements.txt         ← Python dependencies
├── setup.bat                ← Automatic setup script
├── start.bat                ← Quick launch script
├── pyrightconfig.json       ← Type checking configuration
├── .gitignore
├── Fonts/                   ← UI fonts
├── Icon/                    ← Application icon
├── SFX/                     ← Sound effects
├── core/
│   ├── lmstudio_runtime.py  ← Local AI engine
│   └── prompt.txt           ← System prompt
├── actions/
│   ├── __init__.py
│   ├── browser.py           ← Web browser control
│   ├── calendar.py          ← Calendar operations (Outlook + JSON)
│   ├── health.py            ← Health tracking
│   ├── media.py             ← Music/video playback
│   ├── open_app.py          ← Application launcher
│   ├── reminders.py         ← Reminder operations (Outlook + JSON)
│   ├── screen_vision.py     ← Screenshot + Vision AI
│   ├── shell.py             ← PowerShell integration
│   ├── sys_info.py          ← System info (psutil)
│   ├── tts.py               ← Windows SAPI text-to-speech
│   ├── weather.py           ← Weather (OpenWeatherMap)
│   ├── whatsapp.py          ← WhatsApp messaging
│   └── youtube_stats.py     ← YouTube Data API
├── memory/
│   ├── __init__.py
│   ├── memory_manager.py    ← JSON memory manager
│   ├── memory.example.json  ← Memory template
│   └── phone_book.example.json ← Phone book template
└── config/
    ├── api_keys.json        ← API keys (gitignored)
    └── api_keys.example.json ← Template
```

---

## 🔒 Security

- `config/api_keys.json` and `memory/memory.json` are added to `.gitignore` — your API keys and personal data will not be included in the repository.
- `phone_book.json` is also excluded from publishing.
- Only `*.example.json` templates are included in the repository.

---

## 🤝 Contributing

1. Fork this repository
2. Create a new branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -m "New feature: description"`
4. Push your branch: `git push origin feature/new-feature`
5. Open a Pull Request

---

<div align="center">
<p>Developed by <a href="https://github.com/bnsware">bnsware</a> and <a href="https://www.instagram.com/alppunlu">alppunlu</a></p>
</div>
