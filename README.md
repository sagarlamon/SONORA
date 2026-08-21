# SONORA 🎵

```text
    ___  ___  _  _  ___  ___   __   
   / __)/ _ \| \| |/ _ \| _ \ /  \  
   \__ \ (_) | .\ | (_) |   // /\ \ 
   (___/\___/|_|\_|\___/|_|_\\_\/_/ 

      MUSIC  FOR  THE  SHELL
```

[![License: GPL v2+](https://img.shields.io/badge/License-GPL_v2%2B-blue.svg)](./LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-brightgreen.svg)]()
[![Language](https://img.shields.io/badge/Language-C%20%2F%20C%2B%2B20-orange.svg)]()
[![Version](https://img.shields.io/badge/Version-4.2.7-purple.svg)]()

**SONORA** is a fast, lightweight, and visual terminal music player written in C and C++. Designed for shell enthusiasts, audiophiles, and minimalist power users, SONORA plays your local music library with zero algorithmic distractions, instant search playlists, customizable layouts, rich spectrum visualizers, and dynamic color themes.

---

## 🔍 How SONORA Works

SONORA operates on an **Instant-Search & Playlist Generation** workflow:

1. **In-Memory Library Cache**: On launch, SONORA rapidly scans your music folder (e.g. `~/Music`) and builds an in-memory directory tree cache (`~/.config/sonora/sonoralibrary`).
2. **Instant CLI Playlists**: Pass any keyword, artist, or album directly from your terminal prompt to generate interactive playback sessions:
   - `sonora cure` — Finds and enqueues songs or albums matching "cure".
   - `sonora moonlight son` — Fuzzy-matches and plays *Moonlight Sonata*.
   - `sonora artistA:artistB` — Enqueues tracks from multiple artists simultaneously.
3. **High-Fidelity Audio Engine**: Powered by `miniaudio`, `libopus`, `libvorbis`, `taglib`, `libmp4`, `nestegg`, and `libfaad` for low-latency, gapless, 24-bit/192kHz output.
4. **Rich Terminal Visuals**: Features Sixel and ASCII album cover art, real-time CAVA-style FFT audio spectrum visualizers, dynamic gradient progress bars, and rotating vinyl turntable animations.

---

## ✨ Features

- **💿 Dynamic Vinyl Turntable Animation**: Real-time rotating ASCII vinyl disc rendered alongside track metadata during audio playback.
- **📊 Real-time Spectrum Visualizer**: High-density FFT audio visualizer supporting multiple display styles (Smooth Bars, Gradient, Lighten, Reversed, Flat).
- **🌈 Dynamic Gradient Progress Bar**: Progress indicator smoothly interpolates colors in real time from filled track accent to current playback position.
- **🎚️ 10-Band Graphic Equalizer (EQ)**: Built-in 10-band audio equalizer with interactive overlay popup and presets (*Flat*, *Bass Boost*, *Vocal*, *Rock*, *Pop*, *Jazz*, *Electronic*).
- **⌨️ Interactive Command Palette (`:`)**: Vim-style executable prompt (`:theme <name>`, `:vol <0-100>`, `:radio`, `:q`, `:help`).
- **📻 Infinite Auto-Radio**: Automatically enqueues matching local tracks when your playlist ends for endless music flow.
- **📜 Synchronized Lyrics**: Renders synchronized `.lrc` lyrics files as well as embedded SYLT / Vorbis lyrics line-by-line.
- **🖼️ Sixel & ASCII Cover Art**: High-resolution Sixel album graphics or customized ASCII art rendering.
- **🎨 Rich Theme System**: Includes curated color themes (*Sagar's Theme*, *Cyberpunk*, *Catppuccin*, *TokyoNight*, *Gruvbox*, *Nord*, *Kanagawa*) with auto-extracted album color extraction modes.
- **🎧 Gapless & Crossfading**: Seamless transitions between songs with customizable crossfade durations (quick, medium, slow).
- **🐧 Desktop Integration**: Full MPRIS D-Bus media key controls on Linux/macOS and optional Discord Rich Presence.
- **🔒 100% Offline & Private**: Zero tracking or telemetry; all user data remains strictly local.

### Supported Audio Formats

| Format | File Extensions | Support Level |
| :--- | :--- | :--- |
| **MP3** | `.mp3` | Full Support |
| **FLAC** | `.flac` | Full Support (Up to 24-bit/192kHz) |
| **M4A / AAC** | `.m4a`, `.aac` | Full Support (via FAAD2 & LibMP4) |
| **Opus** | `.opus` | Full Support |
| **Ogg Vorbis** | `.ogg` | Full Support |
| **WAV** | `.wav` | Full Support |
| **WebM / Matroska**| `.webm`, `.mka` | Full Support (via Nestegg) |

---

## 🛠️ Complete Installation Guide

### 🐧 1. Linux Installation Guide

#### Option A: Build from Source (Recommended)

##### Step 1: Install Dependencies

Select your Linux distribution to install required build tools and libraries:

- **Arch Linux / Manjaro / EndeavourOS**:
  ```bash
  sudo pacman -Syu --needed git base-devel pkg-config taglib fftw chafa glib2 \
                            opus opusfile libvorbis libogg faad2
  ```

- **Ubuntu / Debian / Linux Mint / Pop!_OS**:
  ```bash
  sudo apt update
  sudo apt install -y git build-essential pkg-config libtag1-dev libfftw3-dev \
                      libopus-dev libopusfile-dev libvorbis-dev libogg-dev \
                      libchafa-dev libglib2.0-dev libfaad-dev
  ```

- **Fedora / RHEL / CentOS Stream**:
  ```bash
  sudo dnf install -y git gcc gcc-c++ make pkg-config taglib-devel fftw-devel \
                      opus-devel opusfile-devel libvorbis-devel libogg-devel \
                      chafa-devel glib2-devel faad2-devel
  ```

- **openSUSE (Tumbleweed / Leap)**:
  ```bash
  sudo zypper install -y git gcc gcc-c++ make pkgconf taglib-devel fftw3-devel \
                         opusfile-devel libvorbis-devel libogg-devel chafa-devel \
                         glib2-devel faad2-devel
  ```

##### Step 2: Clone & Build

```bash
# 1. Clone the repository
git clone https://github.com/sagarlamon/SONORA.git
cd SONORA

# 2. Build the binary using all CPU cores
make -j$(nproc)

# 3. Install system-wide to /usr/local/bin
sudo make install
```

##### Step 3: Launch SONORA

```bash
sonora
```

---

### 🪟 2. Windows Installation Guide (via MSYS2 UCRT64)

The recommended way to build and run SONORA on Windows is using **MSYS2 UCRT64**.

#### Step 1: Install MSYS2
1. Download the installer from [https://www.msys2.org](https://www.msys2.org).
2. Install MSYS2 following the wizard (default installation path: `C:\msys64`).

#### Step 2: Open MSYS2 UCRT64 Terminal
From your Windows Start Menu, search for and open **MSYS2 UCRT64** *(Important: Do NOT use standard MSYS2 or MinGW32)*.

#### Step 3: Install Required Build Tools & Libraries
In the MSYS2 UCRT64 terminal, run:

```bash
pacman -Syu
pacman -S --noconfirm --needed git make mingw-w64-ucrt-x86_64-gcc \
           mingw-w64-ucrt-x86_64-pkg-config mingw-w64-ucrt-x86_64-taglib \
           mingw-w64-ucrt-x86_64-fftw mingw-w64-ucrt-x86_64-chafa \
           mingw-w64-ucrt-x86_64-glib2 mingw-w64-ucrt-x86_64-opus \
           mingw-w64-ucrt-x86_64-opusfile mingw-w64-ucrt-x86_64-libvorbis \
           mingw-w64-ucrt-x86_64-libogg mingw-w64-ucrt-x86_64-faad2
```

#### Step 4: Clone & Compile SONORA

```bash
# Clone the repository inside MSYS2 UCRT64 terminal
git clone https://github.com/sagarlamon/SONORA.git
cd SONORA

# Build the executable
make -j$(nproc)

# Install executable into MSYS2 PATH
make install PREFIX=/ucrt64
```

#### Step 5: Launch SONORA on Windows
Run SONORA directly in the UCRT64 terminal or Windows Terminal:

```bash
sonora
```

> **Tip for Windows Users**: We recommend using **Windows Terminal** (built into Windows 11) for full TrueColor support and optimal ANSI graphics rendering.

---

### 🍎 3. macOS Installation Guide

#### Step 1: Install Xcode Command Line Tools
Open Terminal and run:

```bash
xcode-select --install
```

#### Step 2: Install Homebrew Dependencies
If Homebrew is not installed, install it from [https://brew.sh](https://brew.sh). Then run:

```bash
brew install git make pkg-config taglib fftw opus opusfile libvorbis libogg chafa glib faad2
```

#### Step 3: Clone & Build

```bash
# 1. Clone repository
git clone https://github.com/sagarlamon/SONORA.git
cd SONORA

# 2. Compile and install
make -j$(sysctl -n hw.ncpu)
sudo make install
```

#### Step 4: Launch SONORA

```bash
sonora
```

> **Note for macOS Users**: For high-resolution Sixel album cover rendering, we recommend using a Sixel-capable terminal emulator such as **Kitty**, **WezTerm**, or **iTerm2** (with Sixel enabled).

---

## 🚀 Usage & Commands

### CLI Command Options

| Command | Description |
| :--- | :--- |
| `sonora` | Launch SONORA in interactive TUI mode. |
| `sonora <search-term>` | Instant search and play tracks/albums matching search term. |
| `sonora all` | Enqueue and play all songs in your music library. |
| `sonora albums` | Enqueue and play all albums sequentially in random order. |
| `sonora path "/path/to/Music"` | Set your default music library directory. |
| `sonora list <name>` | Search and load an `.m3u` playlist by name. |
| `sonora .` | Load your favorites playlist (`sonora favorites.m3u`). |
| `sonora theme <theme-name>` | Launch SONORA using a specific color theme. |
| `sonora --noui` | Play music in background mode without TUI interface. |
| `sonora --nocover` | Launch SONORA with album cover art disabled. |
| `sonora --quitonstop` / `-q` | Automatically exit SONORA when the playlist ends. |
| `sonora --version` | Display version and ASCII splash screen. |
| `sonora --help` | Display command-line usage instructions. |

---

## ⌨️ Keybindings & Controls

| Keybinding | Action |
| :--- | :--- |
| <kbd>Space</kbd> / <kbd>p</kbd> | Toggle Play / Pause |
| <kbd>Enter</kbd> | Play or Enqueue selected track/album |
| <kbd>←</kbd> / <kbd>→</kbd> or <kbd>h</kbd> / <kbd>l</kbd> | Previous / Next Song |
| <kbd>+</kbd> / <kbd>-</kbd> | Volume Up / Volume Down |
| <kbd>F2</kbd> – <kbd>F6</kbd> | Switch Views (Playlist, Library, Track, Search, Help) |
| <kbd>Tab</kbd> / <kbd>Shift+Tab</kbd> | Cycle Next / Previous View |
| <kbd>i</kbd> | Cycle Color Mode (Album Cover, Theme, Terminal Palette) |
| <kbd>t</kbd> | Cycle Color Themes |
| <kbd>v</kbd> | Cycle Visualizer Modes |
| <kbd>b</kbd> | Toggle ASCII Cover Art Mode |
| <kbd>m</kbd> | Toggle Lyrics View |
| <kbd>r</kbd> | Cycle Repeat Mode (Off, Repeat Track, Repeat Playlist) |
| <kbd>s</kbd> | Toggle Shuffle Mode |
| <kbd>u</kbd> | Rescan and Update Music Library |
| <kbd>.</kbd> | Add currently playing track to Favorites playlist |
| <kbd>Esc</kbd> / <kbd>q</kbd> | Quit SONORA |

---

## 🎨 Themes & Customization

SONORA comes bundled with curated color themes:

- `sagar` — **Sagar's Signature Theme** (Vibrant Magenta & Deep Crimson Accent)
- `cyberpunk` — Electric Cyan & Neon Yellow
- `catpuccin` — Soft Pastel Palette
- `tokyonight` — Sleek Dark Blue Accent
- `gruvbox` / `gruvboxlight` — Warm Retro Palette
- `nord` — Cool Arctic Blue
- `marianatrench` — Deep Ocean Dark
- `monochrome` — Minimalist High-Contrast Greyscale

### Custom Themes & Layouts

User themes and custom layouts are stored in your user configuration folder:

- **Linux / FreeBSD**: `~/.config/sonora/themes/`
- **macOS**: `~/Library/Preferences/sonora/themes/`
- **Windows**: `C:\Users\<User>\AppData\Local\sonora\themes\`

Create a `.theme` file in your theme directory:

```ini
[theme]
name=My Theme
accent=#e6607a
text=#e0e0e0
logo=#de2b4d
header=#de2b4d
footer=#787878
```

---

## ⚙️ Configuration File Locations

- **Linux / FreeBSD**:
  - Main Settings: `~/.config/sonora/sonorarc`
  - Dynamic State: `~/.config/sonora/sonorastaterc`
  - Library Cache: `~/.config/sonora/sonoralibrary`
  - Error Logs: `~/.local/state/sonora/logs/error.log`
- **macOS**: `~/Library/Preferences/sonora/`
- **Windows**: `C:\Users\<User>\AppData\Local\sonora\`

---

## 📁 Repository Architecture

```text
SONORA/
├── src/                      # C/C++ Source files
│   ├── common/               # State, model, & path definitions
│   ├── data/                 # Library tree, cache, theme, & artist data
│   ├── loader/               # Audio decoders & TagLib metadata wrapper
│   ├── ops/                  # Playback & library operations
│   ├── sound/                # Miniaudio sound engine & buffer management
│   ├── sys/                  # MPRIS D-Bus, Discord RPC, & notifications
│   ├── ui/                   # Renderers, components, visualizers, & CLI
│   ├── update/               # Event loop & state update processor
│   ├── utils/                # Logging, file I/O, & terminal utilities
│   └── sonora.c              # Main application entry point
│
├── include/                  # Embedded third-party headers (miniaudio, stb_image, etc.)
├── themes/                   # Theme definitions (.theme)
├── layouts/                  # Layout configuration files (.layout)
├── shortcut/                 # Desktop integration shortcut & icons (.desktop, .png)
├── sonora.ico                # Multi-resolution Windows binary icon
├── Makefile                  # Cross-platform Makefile
├── LICENSE                   # GNU GPL v2+ License
└── README.md                 # Project documentation
```

---

## 📜 License & Attribution

- **License**: Released under the **GNU General Public License v2 or later (GPL v2+)**. See [LICENSE](./LICENSE) for details.
- **Repository**: [https://github.com/sagarlamon/SONORA](https://github.com/sagarlamon/SONORA)
- **Attribution**: SONORA — **MADE by SAGAR**.
