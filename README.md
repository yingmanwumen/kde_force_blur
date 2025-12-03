# KDE Force Blur Script

## Elevate Your KDE Experience with Dynamic Window Blurring

This script provides a sophisticated solution for enhancing the visual aesthetics of your KDE Plasma desktop by dynamically enforcing blur effects on specified application windows. Designed for users who appreciate a polished and modern look, it ensures that your chosen applications seamlessly integrate with KDE's stunning blur capabilities.

### Principle of Operation

The `kde_force_blur.sh` script operates as a persistent background process, continuously monitoring active windows on your KDE Plasma desktop. It leverages standard X Window System utilities (`xdotool` and `xprop`) to identify and manipulate window properties.

1.  **Window Identification**: The script first identifies windows belonging to a predefined list of application classes (e.g., `neovide`, `dev.warp.Warp`). This allows for targeted blurring of specific applications.
2.  **Property Inspection**: For each identified window, it queries its `_NET_WM_WINDOW_TYPE` (window type) and `_KDE_NET_WM_BLUR_BEHIND_REGION` (KDE-specific blur status) properties.
3.  **Conditional Blurring**:
    *   It checks if the window's type matches any of the `included_types` (e.g., `_NET_WM_WINDOW_TYPE_NORMAL` for regular application windows).
    *   If the window is of an included type and is not already blurred, the script then uses `xprop` to set the `_KDE_NET_WM_BLUR_BEHIND_REGION` property to `1`, thereby activating the blur effect for that window.
4.  **Continuous Monitoring**: The entire process is encapsulated within an infinite loop, with a configurable `interval` (defaulting to 0.2 seconds) between iterations. This ensures that new windows of the specified types are blurred promptly and that the blur effect is maintained.

By selectively applying blur based on application class and window type, the script provides fine-grained control over your desktop's visual presentation, ensuring a consistent and appealing user interface.

### Usage

#### Prerequisites

*   A KDE Plasma desktop environment.
*   `xdotool` and `xprop` utilities installed. These are typically available in most Linux distributions. You can install them using your package manager:
    *   **Debian/Ubuntu**: `sudo apt install xdotool x11-utils`
    *   **Fedora**: `sudo dnf install xdotool xprop`
    *   **Arch Linux**: `sudo pacman -S xdotool xorg-xprop`

#### Configuration

Open the `kde_force_blur.sh` script in a text editor to customize its behavior:

*   **`included_classes`**: This array defines the application window classes that the script will target for blurring.
    ```bash
    included_classes=("neovide" "dev.warp.Warp" "MyCustomApp")
    ```
    To find the class of a window, you can use `xprop WM_CLASS` and click on the desired window. The second string in the output is usually the class name (e.g., `WM_CLASS(STRING) = "neovide", "neovide"` -> `neovide`).

*   **`included_types`**: This array specifies the types of windows that should be blurred. Common types include `_NET_WM_WINDOW_TYPE_NORMAL` for regular application windows. Refer to the [Extended Window Manager Hints (EWMH) specification](https://specifications.freedesktop.org/wm-spec/latest/) for a comprehensive list of window types.
    ```bash
    included_types=("_NET_WM_WINDOW_TYPE_NORMAL" "_NET_WM_WINDOW_TYPE_DIALOG")
    ```

*   **`interval`**: This variable controls the delay (in seconds) between each check for windows. A smaller interval will make the blurring appear more instantaneous but might consume slightly more CPU resources.
    ```bash
    interval=0.2 # Check every 0.2 seconds
    ```

#### Running the Script

1.  **Make the script executable**:
    ```bash
    chmod +x kde_force_blur.sh
    ```

2.  **Run the script in the background**:
    ```bash
    ./kde_force_blur.sh &
    ```
    This will run the script in the background, allowing you to continue using your terminal.

#### Autostart with KDE Plasma

To have the script automatically start when you log into your KDE Plasma session, you can add it to KDE's Autostart applications:

1.  Open **System Settings**.
2.  Navigate to **Startup and Shutdown** -> **Autostart**.
3.  Click **Add Script...**.
4.  Browse to the location of your `kde_force_blur.sh` script.
5.  Select it and choose **Run as a startup script**.
6.  Ensure the "Run in terminal" option is **unchecked** unless you specifically want to see its output in a terminal window.

### Troubleshooting

*   **Script not blurring windows**:
    *   Ensure `xdotool` and `xprop` are installed.
    *   Verify that the `included_classes` and `included_types` arrays in the script correctly match the windows you intend to blur. Use `xprop WM_CLASS` and `xprop _NET_WM_WINDOW_TYPE` to inspect target windows.
    *   Check for any error messages if you run the script directly in a terminal (without `&`).
*   **High CPU usage**: If you notice unusually high CPU usage, consider increasing the `interval` value in the script.
