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
