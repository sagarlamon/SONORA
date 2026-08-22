#!/usr/bin/env bash
# ==============================================================================
# SONORA - Linux Management Script (Update, Install, Clean Reinstall)
# ==============================================================================

set -eo pipefail

# Script directory resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Color formatting helpers
if [[ -t 1 ]]; then
    BOLD='\033[1m'
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    RESET='\033[0m'
else
    BOLD=''
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    MAGENTA=''
    CYAN=''
    RESET=''
fi

info() {
    echo -e "${CYAN}${BOLD}[INFO]${RESET} $1"
}

success() {
    echo -e "${GREEN}${BOLD}[SUCCESS]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}${BOLD}[WARNING]${RESET} $1"
}

error() {
    echo -e "${RED}${BOLD}[ERROR]${RESET} $1" >&2
}

banner() {
    echo -e "${MAGENTA}${BOLD}"
    echo '   ___  ___  _  _  ___  ___   __   '
    echo '  / __)/ _ \| \| |/ _ \| _ \ /  \  '
    echo '  \__ \ (_) | .\ | (_) |   // /\ \ '
    echo '  (___/\___/|_|\_|\___/|_|_\\_\/_/ '
    echo '                                   '
    echo '       MUSIC  FOR  THE  SHELL      '
    echo -e "${RESET}"
}

# Privilege elevation helper
run_sudo() {
    if [[ $EUID -eq 0 ]]; then
        "$@"
    else
        if command -v sudo &>/dev/null; then
            sudo "$@"
        elif command -v doas &>/dev/null; then
            doas "$@"
        else
            error "Root privileges are required for this action, but neither 'sudo' nor 'doas' was found."
            exit 1
        fi
    fi
}

# Detect Linux Distribution and Install Dependencies
install_dependencies() {
    info "Detecting package manager and installing build dependencies..."

    if command -v pacman &>/dev/null; then
        info "Detected Arch Linux / Manjaro / EndeavourOS (pacman)"
        run_sudo pacman -Syu --needed --noconfirm git base-devel pkg-config taglib fftw chafa glib2 opus opusfile libvorbis libogg faad2
    elif command -v apt-get &>/dev/null; then
        info "Detected Debian / Ubuntu / Mint / Pop!_OS (apt)"
        run_sudo apt-get update
        run_sudo apt-get install -y git build-essential pkg-config libtag1-dev libfftw3-dev libopus-dev libopusfile-dev libvorbis-dev libogg-dev libchafa-dev libglib2.0-dev libfaad-dev
    elif command -v dnf &>/dev/null; then
        info "Detected Fedora / RHEL / CentOS (dnf)"
        run_sudo dnf install -y git gcc gcc-c++ make pkg-config taglib-devel fftw-devel opus-devel opusfile-devel libvorbis-devel libogg-devel chafa-devel glib2-devel faad2-devel
    elif command -v zypper &>/dev/null; then
        info "Detected openSUSE (zypper)"
        run_sudo zypper install -y git gcc gcc-c++ make pkgconf taglib-devel fftw3-devel opusfile-devel libvorbis-devel libogg-devel chafa-devel glib2-devel faad2-devel
    elif command -v apk &>/dev/null; then
        info "Detected Alpine Linux (apk)"
        run_sudo apk add git build-base pkgconf taglib-dev fftw-dev opus-dev opusfile-dev libvorbis-dev libogg-dev chafa-dev glib-dev faad2-dev
    elif command -v xbps-install &>/dev/null; then
        info "Detected Void Linux (xbps)"
        run_sudo xbps-install -Sy git base-devel pkg-config taglib-devel fftw-devel opus-devel opusfile-devel libvorbis-devel libogg-devel chafa-devel glib-devel faad2-devel
    else
        warn "Could not automatically identify package manager. Please ensure required libraries (taglib, fftw3, opus, opusfile, vorbis, ogg, chafa, glib2, faad2) are installed."
    fi

    success "Dependencies installation step completed."
}

# Clean local build files
do_clean() {
    info "Cleaning build artifacts..."
    make clean || true
    rm -rf src/obj sonora
    success "Build directory cleaned."
}

# Pull latest changes from git
do_git_pull() {
    if [[ -d ".git" ]] && command -v git &>/dev/null; then
        info "Updating source repository via git pull..."
        git pull || warn "Failed to update git repository. Proceeding with current source files."
    else
        warn "Not a git repository or git not installed; skipping repo update."
    fi
}

# Compile SONORA using all available CPU cores
do_build() {
    local nproc_val
    nproc_val=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)
    info "Building SONORA with ${nproc_val} cores..."
    make -j"${nproc_val}"
    success "Build completed successfully!"
}

# Install SONORA system-wide
do_install_system() {
    info "Installing SONORA system-wide..."
    run_sudo make install
    success "SONORA installed successfully!"
}

# Uninstall SONORA system-wide
do_uninstall() {
    info "Uninstalling SONORA system-wide..."
    if [[ -f "Makefile" ]]; then
        run_sudo make uninstall || true
    fi

    # Fallback binary cleanup if prefix differed
    run_sudo rm -f /usr/local/bin/sonora /usr/bin/sonora

    success "SONORA uninstalled from system."
}

# Purge user configuration and cache files
do_purge_config() {
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/sonora"
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/sonora"

    if [[ -d "$config_dir" || -d "$cache_dir" ]]; then
        info "Removing user configuration and library cache ($config_dir)..."
        rm -rf "$config_dir" "$cache_dir"
        success "User configuration and cache cleared."
    fi
}

# Core Workflows
action_install() {
    info "Starting SONORA Installation Workflow..."
    install_dependencies
    do_clean
    do_build
    do_install_system
    echo
    success "SONORA installation finished! Type 'sonora' in your terminal to launch."
}

action_update() {
    info "Starting SONORA Update Workflow..."
    do_git_pull
    do_clean
    do_build
    do_install_system
    echo
    success "SONORA update finished! Type 'sonora' to launch the updated version."
}

action_clean_reinstall() {
    local purge_cfg=${1:-"no"}
    info "Starting SONORA Clean Reinstall Workflow..."
    do_uninstall

    if [[ "$purge_cfg" == "purge" || "$purge_cfg" == "yes" ]]; then
        do_purge_config
    elif [[ -t 0 ]]; then
        echo -en "${YELLOW}${BOLD}Do you also want to delete user configuration & library cache (~/.config/sonora)? [y/N]: ${RESET}"
        read -r choice
        case "$choice" in
            [yY][eE][sS]|[yY])
                do_purge_config
                ;;
            *)
                info "Keeping existing user config files."
                ;;
        esac
    fi

    do_clean
    do_git_pull
    install_dependencies
    do_build
    do_install_system
    echo
    success "SONORA Clean Reinstall finished successfully!"
}

show_help() {
    banner
    echo -e "${BOLD}Usage:${RESET} $0 [command] [options]"
    echo
    echo -e "${BOLD}Commands:${RESET}"
    echo -e "  ${GREEN}install${RESET}          Install dependencies, compile, and install SONORA system-wide"
    echo -e "  ${GREEN}update${RESET}           Pull latest git commits, rebuild, and reinstall SONORA"
    echo -e "  ${GREEN}reinstall${RESET}        Uninstall, clean build directory, pull latest source, rebuild and reinstall"
    echo -e "  ${GREEN}clean-reinstall${RESET}  Same as reinstall (add --purge flag to also delete ~/.config/sonora)"
    echo -e "  ${GREEN}uninstall${RESET}        Uninstall SONORA binary, man page, and desktop entries"
    echo -e "  ${GREEN}clean${RESET}            Clean local build artifacts (make clean)"
    echo -e "  ${GREEN}deps${RESET}             Install build dependencies for your Linux distribution"
    echo -e "  ${GREEN}help${RESET}             Show this help menu"
    echo
    echo -e "${BOLD}Options:${RESET}"
    echo -e "  ${CYAN}--purge${RESET}          Used with reinstall/clean-reinstall to also remove user config/cache"
    echo
    echo -e "${BOLD}Examples:${RESET}"
    echo "  $0                      Launch interactive menu"
    echo "  $0 update               Quickly update SONORA"
    echo "  $0 clean-reinstall      Clean reinstall SONORA"
    echo "  $0 reinstall --purge    Clean reinstall SONORA including user config wipe"
    echo
}

interactive_menu() {
    while true; do
        clear || true
        banner
        echo -e "${BOLD}Select an action:${RESET}"
        echo -e "  ${CYAN}1)${RESET} Install SONORA ${GRAY}(Dependencies + Build + System Install)${RESET}"
        echo -e "  ${CYAN}2)${RESET} Update SONORA ${GRAY}(Git Pull + Rebuild + System Reinstall)${RESET}"
        echo -e "  ${CYAN}3)${RESET} Clean Reinstall SONORA ${GRAY}(Full Uninstall + Fresh Build + Install)${RESET}"
        echo -e "  ${CYAN}4)${RESET} Clean Reinstall with Config Wipe ${GRAY}(Full Reset + Delete ~/.config/sonora)${RESET}"
        echo -e "  ${CYAN}5)${RESET} Uninstall SONORA ${GRAY}(System Uninstall)${RESET}"
        echo -e "  ${CYAN}6)${RESET} Install Dependencies Only"
        echo -e "  ${CYAN}7)${RESET} Clean Build Artifacts ${GRAY}(make clean)${RESET}"
        echo -e "  ${CYAN}8)${RESET} Exit"
        echo
        echo -en "${BOLD}Enter choice [1-8]: ${RESET}"
        read -r choice

        case "$choice" in
            1)
                echo
                action_install
                break
                ;;
            2)
                echo
                action_update
                break
                ;;
            3)
                echo
                action_clean_reinstall "no"
                break
                ;;
            4)
                echo
                action_clean_reinstall "purge"
                break
                ;;
            5)
                echo
                do_uninstall
                break
                ;;
            6)
                echo
                install_dependencies
                break
                ;;
            7)
                echo
                do_clean
                break
                ;;
            8|q|Q)
                echo "Exiting."
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid selection. Press Enter to try again.${RESET}"
                read -r
                ;;
        esac
    done
}

# Main Command Dispatcher
main() {
    local cmd="${1:-}"
    local flag="${2:-}"

    case "$cmd" in
        install)
            action_install
            ;;
        update)
            action_update
            ;;
        reinstall|clean-reinstall|clean_reinstall)
            if [[ "$flag" == "--purge" ]]; then
                action_clean_reinstall "purge"
            else
                action_clean_reinstall "no"
            fi
            ;;
        uninstall)
            do_uninstall
            if [[ "$flag" == "--purge" ]]; then
                do_purge_config
            fi
            ;;
        clean)
            do_clean
            ;;
        deps|dependencies)
            install_dependencies
            ;;
        help|-h|--help)
            show_help
            ;;
        "")
            interactive_menu
            ;;
        *)
            error "Unknown command: '$cmd'"
            echo
            show_help
            exit 1
            ;;
    esac
}

main "$@"
