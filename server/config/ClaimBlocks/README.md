# 🛡️ ClaimBlocks - Professional Protection System

**ClaimBlocks** is a powerful and lightweight protection mod for Fabric, designed to provide a professional security environment using "Claim Modules" (blocks or custom heads).

---

## 🚀 Commands

| Command | Permission | Description |
| :--- | :--- | :--- |
| `/cb` | `cb.user` | Displays the help menu with all available commands. |
| `/cb menu` | `cb.user` | Opens the management interface for your own protections. |
| `/cb menu <player>` | `cb.admin` | **(Admin)** Opens the protection list of another player. |
| `/cb view` | `cb.user` | Toggles the visual boundaries (particles) of the current zone. |
| `/cb delete` | `cb.user` | Deletes the protection you are looking at (must be the owner/admin). |
| `/cb add <player>` | `cb.user` | Quickly adds a member to the protection you are standing in. |
| `/cb info` | `cb.admin` | **(Admin)** Displays technical info about the current protection. |
| `/cb get <type>` | `cb.admin` | **(Admin)** Gives you 1x of a specific protection module. |
| `/cb give <p> <t> <n>` | `cb.admin` | **(Admin)** Gives `n` modules of type `t` to player `p`. |

---

## 🛠️ Management Interface (GUI)

When you open a protection in the menu, you have several specialized tools:

1.  **🚩 Configure Flags**: Manage PvP, Mob Spawning, Hunger, TNT, and more.
2.  **👥 Manage Members**: Add or remove players from your protection.
3.  **✨ Set Title**: Configure custom titles and subtitles shown when entering the area.
4.  **🏷️ Rename**: Change the display name of your zone for easier identification.
5.  **📍 Location**: Shows the exact coordinates of the module in chat.
6.  **👁️ Hide Module**: Physically removes the protection block/head from the world.
7.  **🚀 Teleport**: **(Admin)** Instantly teleport to the protection's center.
8.  **🗑️ Delete**: Permanently removes the protection and returns the module to your inventory.

---

## ⚙️ Configuration Files

All configurations are located in `config/ClaimBlocks/`:

*   **`settings.json`**: Define your protection modules. You can set the radius (X/Z), custom display names, and textures using Base64 codes from [minecraft-heads.com](https://minecraft-heads.com).
*   **`texts.json`**: Fully customize every message, GUI label, and lore shown in the mod. Supports color codes and formatting.
*   **`claims.json`**: The core database containing all active protections.

---

## 📂 Data Files (World Folder)

The following data is stored specifically for each world in `world/claimblocks/`:

*   **`player_data.json`**: An index for quick lookup of protections owned by each player.

---

## 🔑 Permissions

*   **`cb.user`**: Default access for all players. Allows placing modules and basic management.
*   **`cb.admin`**: Full administrative access. Allows managing any protection, teleporting, and using "give" commands.