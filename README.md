# Techno Kitchen For Dart

A Dart project to send gameplay payloads to 「舞萌DX」.

> This project is a port of the open-source project **Eaquira**.

**ATTENTION: This project will no longer provide detailed endpoint request information from now on. We believe that you will have a way to obtain this information.**

## ✨ Features

1. `getUserId`: Get User ID by QR Code
2. `GetUserPreviewApi`: Fetch user preview data
3. HTTP communication module (can be used to implement other APIs)

---

## 🧪 Testing

1. Create a file `.env` from template
```bash
cp .env.example .env
```

2. Paste a valid QR code string into `QR_CODE`
3. Run test scripts to verify login and API behavior

---

## ⚠️ Disclaimer

This project communicates with AIME and title servers operated by Wahlap. The communication protocol and obfuscation techniques are based on open-source repositories on GitHub.

> No reverse engineering or direct analysis of game binaries was performed during development.

This project may carry **unknown risks**, including but not limited to:

- Data loss
- Score corruption or overwrites
- Incompatibility with server updates
- Unexpected behavior due to logic bugs

**Use at your own risk.**

---

## 📄 License

MIT License

---

## 🤝 Acknowledgements

**Special thanks LEAKERS**