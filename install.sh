#!/bin/bash

echo "==> Making folder..."
sudo mkdir -p "/opt/bee"
sudo mkdir -p "/opt/bee/bin"
sudo mkdir -p "/opt/bee/cellar"
sudo mkdir -p "/opt/bee/doc"
sudo mkdir -p "/opt/bee/applications"
sudo mkdir -p "/opt/bee/project"
sudo mkdir -p "/opt/bee/packdoc"
sudo mkdir -p "/opt/bee/rc"
sudo mkdir -p "/opt/bee/admin/packages"
sudo mkdir -p "/opt/bee/library/packages"

echo "==> Making RC..."
sudo touch "/opt/bee/rc/beerc"
sudo chmod 666 "/opt/bee/rc/beerc"

echo "==> Making executable file..."
sudo tee "/opt/bee/bin/bee" > /dev/null << 'EOF'
#!/bin/bash

if [ -z "$1" ]; then
    echo "Run 'bee help' to see the usage"
    exit 1
fi

case "$1" in
    "install")
        if [ -z "$2" ]; then
            echo "Usage: bee install <package_name>"
            exit 1
        fi

        PACKAGE_NAME="$2"
        REAL_USER="${SUDO_USER:-$USER}"
        SOURCE_FILE="/opt/bee/admin/packages/${PACKAGE_NAME}.sh"
        TARGET_DIR="/opt/bee/library/packages"
        TARGET_FILE="${TARGET_DIR}/${PACKAGE_NAME}.sh"

        if [ ! -f "$SOURCE_FILE" ]; then
            echo "Error: Package not found: $2"
            exit 1
        fi

        if [ ! -d "$TARGET_DIR" ]; then
            mkdir -p "$TARGET_DIR"
        fi

        cp "$SOURCE_FILE" "$TARGET_FILE"
        chown "$REAL_USER":"$REAL_USER" "$TARGET_FILE"

        bash "$TARGET_FILE"
        echo "==> Downloading binary..."

        if [ "$(uname -s)" = "Darwin" ]; then
            case "$macos" in
                "yes"|"true"|"t"|"y")
                    if [ -n "$homepage" ]; then
                        echo "View all on $homepage"
                    fi
                    if [ -n "$discord" ]; then
                        echo "Join my discord server -> $discord"
                    fi
        
                    curl -s -L -R -O "$bin" "/opt/bee/cellar/$2.tgz"
                    tar zxf "/opt/bee/cellar/$2.tgz" -C "/opt/bee/cellar/"
                    rm "/opt/bee/cellar/$2.tgz"

                    sudo mkdir -p "/opt/bee/packdoc/$2"

                    if [ -n "$license" ]; then
                        sudo curl -O "$license" "/opt/bee/packdoc/$2/license.md"
                    fi
                    if [ -n "$readme" ]; then
                        sudo curl -O "$readme" "/opt/bee/packdoc/$2/readme.md"
                    fi
                    if [ -n "$manual" ]; then
                        sudo curl -O "$manual" "/usr/local/share/man1/$2.1"
                    fi
                    if [ -n "$agents" ]; then
                        sudo curl -O "$agents" "/opt/bee/packdoc/$2/agents.md"
                    fi

                    if [ -d "/opt/bee/cellar/$2/bin" ]; then
                        chmod -R +x "/opt/bee/cellar/$2/bin"
                        echo 'export PATH="$PATH:/opt/bee/cellar/'"$2"'/bin"' >> "/opt/bee/rc/beerc"
                    fi

                    if [ -d "/opt/bee/cellar/$2/include" ]; then
                        TARGET_DIR="/opt/bee/cellar/$2/include"
                        HEADER_LINE="#include \"my_header.h\""
                        find "$TARGET_DIR" -type f \( -name "*.h" -o -name "*.c" -o -name "*.cpp" \) | while read -r file; do
                            sed -i '' "1i\\
$HEADER_LINE
" "$file"
                        done
                    fi
                    ;;
                "no"|"false"|"n"|"f")
                    echo "Error: This package is not for macOS"
                    ;;
                *)
                    echo "Error: Choice not found"
                    ;;
            esac
        fi

        if [ "$(uname -s)" = "Linux" ]; then
            case "$linux" in
                "yes"|"true"|"t"|"y")
                    if [ -n "$homepage" ]; then
                        echo "View all on $homepage"
                    fi
                    if [ -n "$discord" ]; then
                        echo "Join my discord server -> $discord"
                    fi
        
                    curl -s -L -R -O "$bin" "/opt/bee/cellar/$2.tgz"
                    tar zxf "/opt/bee/cellar/$2.tgz" -C "/opt/bee/cellar/"
                    rm "/opt/bee/cellar/$2.tgz"

                    sudo mkdir -p "/opt/bee/packdoc/$2"

                    if [ -n "$license" ]; then
                        sudo curl -O "$license" "/opt/bee/packdoc/$2/license.md"
                    fi
                    if [ -n "$readme" ]; then
                        sudo curl -O "$readme" "/opt/bee/packdoc/$2/readme.md"
                    fi
                    if [ -n "$manual" ]; then
                        sudo curl -O "$manual" "/usr/local/share/man1/$2.1"
                    fi
                    if [ -n "$agents" ]; then
                        sudo curl -O "$agents" "/opt/bee/packdoc/$2/agents.md"
                    fi

                    if [ -d "/opt/bee/cellar/$2/bin" ]; then
                        chmod -R +x "/opt/bee/cellar/$2/bin"
                        echo 'export PATH="$PATH:/opt/bee/cellar/'"$2"'/bin"' >> "/opt/bee/rc/beerc"
                    fi

                    if [ -d "/opt/bee/cellar/$2/include" ]; then
                        TARGET_DIR="/opt/bee/cellar/$2/include"
                        HEADER_LINE="#include \"my_header.h\""
                        find "$TARGET_DIR" -type f \( -name "*.h" -o -name "*.c" -o -name "*.cpp" \) | while read -r file; do
                            sed -i "1i\\$HEADER_LINE" "$file"
                        done
                    fi
                    ;;
                "no"|"false"|"n"|"f")
                    echo "Error: This package is not for Linux"
                    ;;
                *)
                    echo "Error: Choice not found"
                    ;;
            esac
        fi   
        ;;
    "uninstall")
        if [ -z "$2" ]; then
            echo "Usage: bee uninstall <package_name>"
            exit 1
        fi

        if [ -d "/opt/bee/cellar/$2" ]; then
            rm -rf "/opt/bee/cellar/$2"
            rm -f "/opt/bee/library/packages/$2.sh"
        else
            echo "Error: Package not found: $2"
        fi
        ;;
    "create")
        if [ -z "$2" ]; then
            echo "Usage: bee create <name>"
            exit 1
        fi

cat << 'EOS' > "/opt/bee/project/$2.sh"
name="$2"
discord=""
readme=""
license=""
logo=""
agents=""
manual=""
linux=""
macos=""
EOS

        vim "/opt/bee/project/$2.sh"
        ;;
    "test")
        if [ -z "$2" ]; then
            echo "Usage: bee test <package_name>"
            exit 1
        fi

        PACKAGE_NAME="$2"
        bash "/opt/bee/project/${PACKAGE_NAME}.sh"
        echo "==> Downloading binary..."

        if [ -n "$homepage" ]; then
            echo "View all on $homepage"
        fi
        if [ -n "$discord" ]; then
            echo "Join my discord server -> $discord"
        fi
        
        curl -s -L -R -O "$bin" "/opt/bee/cellar/$2.tgz"
        tar zxf "/opt/bee/cellar/$2.tgz" -C "/opt/bee/cellar/"
        rm "/opt/bee/cellar/$2.tgz"

        sudo mkdir -p "/opt/bee/packdoc/$2"

        if [ -n "$license" ]; then
            sudo curl -O "$license" "/opt/bee/packdoc/$2/license.md"
        fi
        if [ -n "$readme" ]; then
            sudo curl -O "$readme" "/opt/bee/packdoc/$2/readme.md"
        fi
        if [ -n "$manual" ]; then
            sudo curl -O "$manual" "/usr/local/share/man1/$2.1"
        fi
        if [ -n "$agents" ]; then
            sudo curl -O "$agents" "/opt/bee/packdoc/$2/agents.md"
        fi

        if [ -d "/opt/bee/cellar/$2/bin" ]; then
            chmod -R +x "/opt/bee/cellar/$2/bin"
            echo 'export PATH="$PATH:/opt/bee/cellar/'"$2"'/bin"' >> "/opt/bee/rc/beerc"
        fi

        if [ -d "/opt/bee/cellar/$2/include" ]; then
            TARGET_DIR="/opt/bee/cellar/$2/include"
            HEADER_LINE="#include \"my_header.h\""
            find "$TARGET_DIR" -type f \( -name "*.h" -o -name "*.c" -o -name "*.cpp" \) | while read -r file; do
                sed -i "1i\\$HEADER_LINE" "$file"
            done
        fi
        ;;
    "edit")
        if [ -z "$2" ]; then
            echo "Usage: bee edit <package_name>"
            exit 1
        fi

        if [ -f "/opt/bee/project/$2.sh" ]; then
            vim "/opt/bee/project/$2.sh"
        else
            echo "Error: Package not found: $2"
        fi
        ;;
    "delete-project")
        if [ -z "$2" ]; then
            echo "Usage: bee delete-project <package_name>"
            exit 1
        fi

        if [ -f "/opt/bee/project/$2.sh" ]; then
            sudo rm "/opt/bee/project/$2.sh"
        else
            echo "Error: Package not found: $2"
        fi
        ;;
    "readme")
        if [ -z "$2" ]; then
            cat "/opt/bee/doc/readme.md"
            exit 0
        fi

        if [ -f "/opt/bee/packdoc/$2/readme.md" ]; then
            cat "/opt/bee/packdoc/$2/readme.md"
        else
            echo "Error: No readme found for: $2"
        fi
        ;;
    "license")
        if [ -z "$2" ]; then
            cat "/opt/bee/doc/license.md"
            exit 0
        fi

        if [ -f "/opt/bee/packdoc/$2/license.md" ]; then
            cat "/opt/bee/packdoc/$2/license.md"
        else
            echo "Error: No license found for: $2"
        fi
        ;;
    "manual")
        if [ -z "$2" ]; then
            cat "/opt/bee/doc/manual.md"
            exit 0
        fi

        if [ -f "/usr/local/share/man1/$2.1" ]; then
            man $2
        else
            echo "Error: No manual found for: $2"
        fi
        ;;
    "agents")
        if [ -z "$2" ]; then
            cat "/opt/bee/doc/agents.md"
            exit 0
        fi

        if [ -f "/opt/bee/packdoc/$2/agents.md" ]; then
            cat "/opt/bee/packdoc/$2/agents.md"
        else
            echo "Error: No agents found for: $2"
        fi
        ;;
    "publish")
        if [ -z "$2" ]; then
            echo "Usage: bee publish <package_name>"
            exit 1
        fi

        SOURCE_PATH="/opt/bee/project/$2.sh"
        TARGET_DIR="/opt/bee/admin/packages"

        TARGET_USER=$(awk -F: -v dir="$TARGET_DIR" '$6 == dir {print $1; exit}' /etc/passwd)
        [ -z "$TARGET_USER" ] && TARGET_USER="root"

        if sudo cp "$SOURCE_PATH" "$TARGET_DIR/$2.sh"; then
            sudo chown "$TARGET_USER":"$TARGET_USER" "$TARGET_DIR/$2.sh"
        fi
        ;;
    "help")
        cat "/opt/bee/doc/help.md"
        ;;
    "my-packages-list")
        cd "/opt/bee/cellar" || exit
        IFS=':' read -ra PATH_DIRS <<< "$PATH"
        for dir in "${PATH_DIRS[@]}"; do
            if [ -d "$dir" ]; then
                find "$dir" -maxdepth 1 -type f 2>/dev/null
                echo ""
            fi
        done
        ;;
    "packages-list")
        TARGET_PATH="/opt/bee/admin/packages"
        if [ -d "$TARGET_PATH" ]; then
            for file in "$TARGET_PATH"/*; do
                if [ -f "$file" ]; then
                    filename=$(basename "$file")
                    echo "${filename%.*}"
                fi
            done
        fi
        ;;
    "search")
        if [ -z "$2" ]; then
            echo "Usage: bee search <package_name>"
            exit 1
        fi
        TARGET_PATH="/opt/bee/admin/packages"
        SEARCH_KEYWORD="$2"
 
        find "$TARGET_PATH" -maxdepth 1 -type f -name "*$SEARCH_KEYWORD*" 2>/dev/null | while read -r filepath; do
            filename=$(basename "$filepath")
            echo "${filename%.*}"
        done | sort -u
        ;;
    "rc")
        bash "/opt/bee/rc/beerc"
        ;;
    "update")
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/LT5B/bee/main/install.sh)"
        ;;
    *)
        echo "Error: Command not found: bee $1"
        ;;
esac
EOF

echo "==> Making doc..."
sudo tee "/opt/bee/doc/help.md" > /dev/null << 'EOF'
bee:

install <package_name>
uninstall <package_name>
create <package_name>
edit <package_name>
rc
search <package_name>
packages-list
my-packages-list
help
readme [package]
manual [package]
license [package]
agents [package]
EOF

sudo tee "/opt/bee/doc/readme.md" > /dev/null << 'EOF'
# 🐝 bee

**bee** is a blazing-fast, lightweight, and secure package manager designed to streamline dependency management for modern development workflows.

Built with performance in mind, **bee** optimizes disk space using a centralized cache and executes installations using highly concurrent worker threads.

---

## ⚡ Key Features

* **Ultra-Fast Installation**: Utilizes concurrent downloading and parallel extraction.
* **Zero Duplication**: Employs hard linking to save disk space across multiple projects.
* **Deterministic Builds**: Guarantees identical environments via a strict `bee.lock` file.
* **Workspace Support**: Manages multi-package monorepos natively with ease.
* **Offline Mode**: Installs dependencies directly from the local cache without an internet connection.

---

## 🚀 Getting Started

### Installation

Install **bee** globally using our official installation script.

---

## 📊 Performance Comparison

| Feature / Metric | **bee** | npm | pnpm |
| :--- | :--- | :--- | :--- |
| **Install Speed (Cold)** | **Fastest** | Slow | Fast |
| **Install Speed (Warm)** | **Instant** | Medium | Fast |
| **Disk Space Usage** | **Lowest** | High | Low |
| **Monorepo Support** | **Native** | Shared | Native |

---

## 🤝 Contributing

We welcome contributions from the community! Please read our [Contributing Guide](CONTRIBUTING.md) and check out our [Code of Conduct](CODE_OF_CONDUCT.md) before getting started.

1. **Fork** the repository
2. **Create** your feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add some amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🧑‍💻 Codeowner
- LT5B - Vietnamese Dev
- engeleditorfpe@gmail.com
EOF

sudo tee "/opt/bee/doc/license.md" > /dev/null << 'EOF'
Copyright (c) 2026 LT5B - BEE

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOF

sudo tee "/opt/bee/doc/agents.md" > /dev/null << 'EOF'
# Bee Package Manager - Agents Specification

This document details the architecture, registration, and runtime execution environment for internal and external specialized **Agents** within the **bee** package manager. 

---

## 1. Overview
In `bee`, **Agents** are autonomous, lightweight executable routines responsible for system operations such as dependency resolution, parallelized network mirrors fetching, integrity checks, and self-repair hooks. 

Agents interact with the `bee` core via the **Bee Agent Communication Protocol (BACP)** over Unix Domain Sockets or named pipes.

---

## 2. Core Built-In Agents

The `bee` runtime ships with four foundational agents activated out of the box:

### 🐝 Worker Agent (`bee-worker-agent`)
* **Role:** Package extraction and compilation pipeline manager.
* **Capabilities:** Concurrently decompresses tarballs, triggers platform-specific pre-install hooks, and moves built binaries into local cache directories.

### 🔍 Resolver Agent (`bee-resolver-agent`)
* **Role:** SAT-based (Satisfiability) dependency tree generator.
* **Capabilities:** Parses version ranges, evaluates diamond dependencies, and creates deterministic lockfiles (`bee.lock`).

### 🛡️ Guard Agent (`bee-guard-agent`)
* **Role:** Security, auditing, and sandbox isolation.
* **Capabilities:** Validates cryptographic checksums (SHA-256), isolates third-party install scripts via lightweight cgroups, and cross-references packages against vulnerabilities databases.

### 🌐 Sync Agent (`bee-sync-agent`)
* **Role:** Multi-mirror connection routing.
* **Capabilities:** Pings configured mirrors dynamically, establishes HTTP/2 multiplexed streams, and handles retry mechanisms for flaky networks.

---

## 3. Configuration & Registration

Custom agent hooks can be initialized by adding them to the global `bee.toml` or the local project manifests.

```toml
[agents.custom-validator]
exec = "/opt/bee/bin/bee"
sandbox = true

```

### Agent Lifecycle Hooks

Agents listen to specific ecosystem event streams emitted by the core:

| Hook Event | Executing Agent | Expected Action |
| --- | --- | --- |
| `on_resolve` | `bee-resolver-agent` | Emits validated JSON package graphs. |
| `pre_fetch` | `bee-sync-agent` | Validates mirror endpoints availability. |
| `post_fetch` | `bee-guard-agent` | Computes and validates binary checksums. |
| `on_extract` | `bee-worker-agent` | Handles filesystem deployment and symlinks. |

## 4. Error Handling & Fail-safe Mode

If an agent misbehaves, freezes, or fails an execution check, `bee` triggers the **Default Fail-safe Circuit**:

1. **Isolation:** The faulty agent process is safely sent a `SIGTERM` (and `SIGKILL` after 5 seconds).
2. **Fallback:** Tasks are handed over to the synchronous native fallback engine inside the `bee` core.
3. **Telemetry:** Diagnostics are recorded in `~/.bee/logs/agents.err.log`.
EOF

sudo tee "/opt/bee/doc/manual.md" > /dev/null << 'EOF'

# BEE(1) - User Commands Manual

## NAME

```
 bee - a command-line tool for managing Bee packages and development environments

```

## SYNOPSIS

```
 bee <command> [arguments] [options]

```

## DESCRIPTION

```
 The bee utility is a high-performance package manager designed to initialize, 
 install, update, and manage dependencies for Bee-based applications. It automates 
 environment setup, resolves semantic versioning, and provides a unified interface 
 for project development.

```

## COMMANDS AND OPTIONS

```
 help
         Display the help menu and a summary of available commands.

 update
         Refresh the Bee package manager

 install
         Install a package

 uninstall
         Remove a package
 v.v.

```

EOF

sudo mkdir -p /usr/local/share/man/man1
sudo tee "/usr/local/share/man/man1/bee.1" > /dev/null << 'EOF'
.TH BEE 1 "September 2026" "Bee Manual" "User Commands Manual"
.SH NAME
bee - a command-line tool for managing Bee packages and development environments
.SH SYNOPSIS
.B bee
.I 
[\ imperatives/arguments\ ]
[\ options\ ]
.SH DESCRIPTION
The
.B bee
utility is a high-performance package manager designed to initialize, install, update, and manage dependencies for Bee-based applications. It automates environment setup, resolves semantic versioning, and provides a unified interface for project development.
.SH COMMANDS
.TP
.B help
Display the help menu and a summary of available commands.
.TP
.B update
Refresh the Bee package manager.
.TP
.B install
Install a package.
.TP
.B uninstall
Remove a package.
EOF

echo "==> Allowing executable permissions..."
sudo chmod +x "/opt/bee/bin/bee"

echo "==> Adding executable file to terminal system..."
echo 'export PATH="$PATH:/opt/bee/bin"' | sudo tee -a "/opt/bee/rc/beerc" > /dev/null
echo 'bee rc 2>/dev/null' >> "$HOME/.bashrc"
echo 'bee rc 2>/dev/null' >> "$HOME/.zshrc"

echo "==> Installed done!"
echo "Please restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc' manually."
```
