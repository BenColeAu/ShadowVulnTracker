# ShadowVulnTracker (SVT) - Untested

**ShadowVulnTracker** is a lightweight, high-visibility tactical addon designed specifically for **Priests and Warlocks** on the **Turtle WoW (1.12.1)** client. It provides a real-time, resizable countdown for the "Shadow Vulnerability" debuff on your current target.

## 🌟 Features

* **10-Second Precision**: Specifically tuned to the Turtle WoW Shadow Vulnerability duration logic.
* **SuperWow Compatible**: Utilizes extended API features when available but remains fully functional on the standard 1.12.1 client.
* **Fully Resizable**: Includes a dedicated resize handle (bottom-right) to scale the icon from a small indicator to a massive screen-center warning.
* **Test Mode Loop**: A smart test mode that loops the timer indefinitely, allowing for perfect positioning and sizing without the icon disappearing.
* **Smart Locking**: Right-click the minimap button to lock the frame’s position and hide the resize handle during raids.
* **Persistent Settings**: Automatically saves your custom location, scale, and lock status across character relogs and game restarts.

---

## 🛠 Installation

1.  Download the latest version of the addon.
2.  Navigate to your Turtle WoW directory: `World of Warcraft/Interface/AddOns/`.
3.  Create a folder named **exactly** `ShadowVulnTracker`.
4.  Place `ShadowVulnTracker.toc` and `ShadowVulnTracker.lua` inside that folder.
5.  Restart your game or type `/reload` in-game.

---

## 🎮 How to Use

### Minimap Button Controls
* **Left-Click**: Toggles **Test Mode**. (The icon will appear and loop the 10s timer for setup).
* **Right-Click**: Toggles **Lock**. (Prevents accidental dragging and hides the resize grip).
* **Drag**: Move the minimap button around the minimap ring.

### Configuration
* **To Position**: Enable **Test Mode** (Left-click Minimap), then click and drag the Shadow Bolt icon to your desired location.
* **To Resize**: While the frame is **Unlocked**, click and drag the small handle in the **bottom-right corner** of the main icon.
* **To Reset**: If you lose the icon off-screen or want to revert to defaults, type `/svtreset` in chat.

---

## ⌨️ Slash Commands

| Command | Description |
| :--- | :--- |
| `/svtreset` | Snaps the tracker to the center of the screen and resets size to 150x150. |

---

## ⚠️ Compatibility Notes

* **Debuff Limit**: On the standard 1.12.1 client, Blizzard only displays the first 16 debuffs. If Shadow Vulnerability is pushed past slot 16 in a 40-man raid, the tracker may hide. Using the **SuperWow** client extension is highly recommended to bypass this limitation.
* **Localization**: This version uses icon-path detection (`Spell_Shadow_ShadowBolt`), making it compatible with all language clients (English, Chinese, German, etc.).

---

## 📜 Credits
**Author:** Varnek - East Oceanic Trading Co  
**Platform:** Turtle WoW (1.12.1)  

*May your crits be high and your resists be low.*