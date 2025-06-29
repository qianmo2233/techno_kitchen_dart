# Techno Kitchen For Dart

A Dart project to send gameplay payloads to 「舞萌DX」.

> This project is a port of the open-source project **Eaquira**.

## ✨ Features

1. Retrieve the latest SDGB opt file
2. `UserLoginApi`: Log in
3. `UserLogoutApi`: Log out
4. Advance area travel by 99 kilometers
5. Score submission (overwrites existing records)
6. `GetUserPreviewApi`: Fetch user preview data
7. Basic HTTP communication module (can be used to implement other APIs)
8. `UpsertUserChargelogApi`: Send charge logs (e.g.,   6X boost tickets)
9. Unlock all songs from **「舞萌DX」** up to **「舞萌DX 2024」**  
   > ⚠️ Re:Master charts for songs that have them are not unlocked yet
10. Unlock a specific song
11. `GetUserDataApi`: Fetch detailed user data (including all records and collections)

The following features include a complete login workflow:

- area travel
- score submission
- send boost tickets
- unlock specific song
- fetch user data

> Notes:
> - Feature 5 will overwrite existing scores with those configured in settings.
> - Features 4 and 10 will simulate a play record for “PANDORA PANDOXXX” Re:Master chart but **will not overwrite** existing scores.

---

## 🧪 Testing

1. Create a file `test/qrcode.txt`
2. Paste a valid QR code string into it
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