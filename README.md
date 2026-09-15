# bee

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
