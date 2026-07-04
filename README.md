# scrcpy Installer

Here is a quick script to download and install scrcpy.

**Windows:**
```powershell
irm https://raw.githubusercontent.com/Dxrmy/scrcpy-installer/main/install.ps1 | iex
```

**macOS & Linux:**
```bash
curl -sL https://raw.githubusercontent.com/Dxrmy/scrcpy-installer/main/install.sh | bash
```

## Usage

### Running scrcpy

Once installed, you can start mirroring your Android device by following these steps:

1. Connect your Android device to your computer via USB.
2. Ensure **USB Debugging** is enabled in your device's Developer Options.
3. Open a new terminal or command prompt (you may need to restart it if you just installed scrcpy).
4. Run the following command:

```bash
scrcpy
```

### Uninstalling

If you want to uninstall scrcpy later, simply run the installation command again and select the **Uninstall** option (`2`) from the interactive menu.
