# mnoxa

A bootstrap script to initialize `mise`, install tools, and configure `fnox` with `age`.

---

## 🚀 What this does

* Creates `mise.toml`
* Installs required tools via `mise`
* Ensures `age` is installed
* Generates or reuses an `age` key
* Creates `fnox.toml` using your public key
* Safe to re-run (idempotent)

---

## 📦 Requirements

* `mise` installed

```bash
mise --version
```

---

## ⚡ Usage

### Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/tumit/mnoxa/main/scripts/init-mnoxa.sh | bash
```

---

### Safer way

```bash
curl -fsSL -o mnoxa.sh https://raw.githubusercontent.com/tumit/mnoxa/main/scripts/init-mnoxa.sh
bash mnoxa.sh
```

---

## 🔐 fnox + age setup

### 1. Install age (if missing)

```bash
# Arch Linux
sudo pacman -S age

# macOS
brew install age
```

---

### 2. Key management

* Path: `~/.config/fnox/age.txt`
* If exists → reused
* If not → generated automatically

```bash
age-keygen -o ~/.config/fnox/age.txt
```

---

### 3. Generated fnox.toml

```toml
default_provider = "age"

[providers.age]
type = "age"
recipients = ["age1xxxx..."]
```

---

## 📁 Project Structure

```
.
├── scripts/
│   └── mnoxa.sh
└── README.md
```

---

## 🔁 Idempotency

* `mise.toml` → not overwritten
* `fnox.toml` → not overwritten
* `age key` → reused

---

## 🛠 Troubleshooting

```bash
mise doctor
mise ls
```

---

## ⚠️ Notes

* `"latest"` is not reproducible → consider pinning versions
* Keep `age.txt` secure (contains private key)
* Review scripts before running (`curl | bash` risk)

---

## 📌 Future Improvements

* [ ] `--force` flag
* [ ] Version pinning
* [ ] Auto-install `age`
* [ ] CI integration

---

## 📄 License

MIT
