"""My widget customizations stuff."""

from libqtile import bar, widget
from libqtile.lazy import lazy

# from libqtile.log_utils import logger
import os
import shutil
import subprocess

my_terminal = "alacritty"

blue_colors = {
    "white": "#ffffff",
    "blue1": "#eff3fd",
    "blue2": "#e5f3fd",
    "blue3": "#dbf3fa",
    "blue4": "#b7e9f7",
    "blue5": "#92dff3",
    "blue6": "#296d98",
    "blue7": "#2f4d7d",
    "blue8": "#215578",
    "blue9": "#152338",
}

colors = {
    "black": "#000000",
    "gray": "#6e6c7e",
    "white": "#ffffff",
    "teal": "#b5e8e0",
    "faded_blue": "#566c73",
    "lighter_blue": "#dbf0fe",
    "light_blue": "#add8e6",
    "dark_blue": "#152238",
    "green": "#90ee90",
    "dark_pink": "#f28fad",
    "light_pink": "#f5d0f0",
    "dark_orange": "#ff8886",
    "orange": "#ffaf7a",
    "red": "#ff7f7f",
    "yellow": "#ffff99",
    "transparent": "#00000000",
}


backgrounds = {
    "group_box": colors["dark_blue"],
    "window_name": colors["dark_blue"],
    "update_block": blue_colors["blue1"],
    # "gpu_block": colors["green"],
    "gpu_block": blue_colors["blue2"],
    # "cpu_block": colors["dark_pink"],
    "cpu_block": blue_colors["blue3"],
    # "ram_block": colors["light_pink"],
    # "ram_block": "#92dff3",
    "ram_block": blue_colors["blue4"],
    "memory_block": blue_colors["blue5"],
    # "volume_block": colors["dark_orange"],
    "volume_block": blue_colors["blue6"],
    "brightness_block": colors["orange"],
    "battery_block": colors["green"],
    # "clock_block": colors["yellow"],
    "clock_block": blue_colors["blue7"],
    # "current_layout": colors["lighter_blue"],
    "current_layout": colors["dark_blue"],
    "quick_exit": colors["black"],
}


def get_gpu_stats():
    """GPU temperature, utilisation and VRAM used, from one nvidia-smi call.

    Newer drivers report the temperature with decimals (e.g. "42.50"), which
    breaks qtile's NvidiaSensors widget, so parse it ourselves.
    """
    try:
        out = subprocess.run(
            [
                "nvidia-smi",
                "--query-gpu=temperature.gpu,utilization.gpu,memory.used",
                "--format=csv,noheader,nounits",
            ],
            capture_output=True,
            text=True,
            timeout=5,
        ).stdout
        temp, usage, mem = (
            float(v) for v in out.splitlines()[0].split(",")
        )
    except (OSError, subprocess.SubprocessError, ValueError, IndexError):
        return "N/A"
    return f"{temp:.0f}°C {usage:3.0f}% {mem:.0f}M"


def has_nvidia_gpu():
    """True if nvidia-smi is installed."""
    return shutil.which("nvidia-smi") is not None


def get_cpu_temp():
    """Get CPU temperature for AMD CPUs (no core info)."""
    try:
        out = subprocess.run(
            ["sensors"], capture_output=True, text=True, timeout=5
        ).stdout
    except (OSError, subprocess.SubprocessError):
        return "N/A"
    for line in out.splitlines():
        if line.startswith(("CPUTIN:", "CPU:", "Tctl:")):
            # e.g. "Tctl:  +36.5°C" -> "36"
            try:
                return f"{float(line.split()[1].strip('+°C')):.0f}"
            except (IndexError, ValueError):
                break
    return "N/A"


def border_symbol(direction, foreground, background, fontsize=25):
    """Powerline arrow key symbol."""
    if direction == "left":
        # text = ""
        text = ""
    elif direction == "right":
        # text = ""
        text = ""
    return [
        widget.TextBox(
            text=text,
            foreground=foreground,
            background=background,
            fontsize=fontsize,
            padding=0,
            font="MesloLGS NF",
        ),
    ]


def group_box():
    """Workspaces."""
    return [
        widget.GroupBox(
            active=colors["light_blue"],
            # inactive="#add8e680",
            # inactive="#78909c",
            inactive=colors["faded_blue"],
            highlight_method="line",
            highlight_color=colors["dark_blue"],
            other_current_screen_border=blue_colors["blue8"],
            other_screen_border=blue_colors["blue8"],
            this_current_screen_border=colors["lighter_blue"],
            this_screen_border=colors["lighter_blue"],
            background=backgrounds["group_box"],
            padding=10,
            fontsize=25,
        ),
    ]


def audio_block():
    """Show current audio info."""
    return [
        widget.Mpris2(
            foreground=colors["lighter_blue"],
            # background="#eff3fd",
            # background="#566c73",
            display_metadata=["xesam:title", "xesam:artist"],
            max_chars=40,
            playing_text="    {track}",
            paused_text="    {track}",
            scroll=False,
            scroll_interval=0.01,
            fontsize=12,
            font="Iosevka Nerd Font",
        ),
    ]


def window_name():
    """Active window name."""
    return [
        widget.WindowName(
            foreground=colors["white"],
            background=backgrounds["window_name"],
            max_chars=40,
            width=bar.CALCULATED,
            # padding=13,
        ),
    ]


def app_block():
    """Open apps."""
    return [
        widget.WidgetBox(
            text_closed="",
            text_open="",
            close_button_location="right",
            fontsize=15,
            font="Iosevka Nerd Font",
            widgets=[
                widget.Systray(padding=2, icon_size=15),
                widget.Sep(linewidth=0, padding=5),
            ],
        )
    ]


def gpu_block():
    """GPU information."""
    return [
        widget.Sep(
            linewidth=0, padding=5, background=backgrounds["gpu_block"]
        ),
        widget.Image(
            filename=f"{os.environ['HOME']}/.config/qtile/icons/gpu.png",
            background=backgrounds["gpu_block"],
            mouse_callbacks={
                "Button1": lazy.spawn(my_terminal + " -e nvtop")
            },
        ),
        widget.Sep(
            linewidth=0, padding=5, background=backgrounds["gpu_block"]
        ),
        widget.GenPollText(
            foreground=colors["dark_blue"],
            background=backgrounds["gpu_block"],
            func=get_gpu_stats,
            update_interval=2,
            mouse_callbacks={"Button1": lazy.spawn(my_terminal + " -e nvtop")},
            padding=5,
        ),
    ]


def update_block():
    """Check AUR for updates."""
    return [
        widget.TextBox(
            text="",
            foreground=colors["dark_blue"],
            # background=colors["white"],
            background=backgrounds["update_block"],
            # background="#e5f3fd",
            # "#E5F3FD"
            fontsize=13,
            font="Iosevka Nerd Font",
            mouse_callbacks={
                "Button1": lazy.spawn(f"{my_terminal} -e paru")
            },
        ),
        widget.CheckUpdates(
            display_format="{updates}",
            colour_have_updates=colors["dark_blue"],
            colour_no_updates=colors["dark_blue"],
            background=backgrounds["update_block"],
            # background="#e5f3fd",
            distro="Arch_checkupdates",
            update_interval=120,
            no_update_string="0",
            mouse_callbacks={
                "Button1": lazy.spawn(f"{my_terminal} -e paru")
            },
        ),
    ]


def memory_block():
    """Disk free space information using `df`."""
    return [
        widget.TextBox(
            text="",
            # text="",
            foreground=colors["dark_blue"],
            background=backgrounds["memory_block"],
            fontsize=13,
            font="Iosevka Nerd Font",
            mouse_callbacks={
                "Button1": lazy.spawn(
                    f"{my_terminal}  -e watch df -h /"
                )
            },
        ),
        widget.DF(
            format="{p} {uf:.0f}{m} {r:.0f}%",
            # format="{uf}{m}",
            visible_on_warn=False,
            foreground=colors["dark_blue"],
            background=backgrounds["memory_block"],
            update_interval=120,
            warn_space=100,
            mouse_callbacks={
                "Button1": lazy.spawn(
                    f"{my_terminal}  -e watch df -h /"
                )
            },
        ),
    ]


def cpu_block():
    """CPU information."""
    return [
        widget.TextBox(
            text="",
            foreground=colors["dark_blue"],
            background=backgrounds["cpu_block"],
            mouse_callbacks={"Button1": lazy.spawn("psensor")},
            fontsize=13,
            font="Iosevka Nerd Font",
        ),
        widget.GenPollText(
            fmt="{}°C",
            foreground=colors["dark_blue"],
            background=backgrounds["cpu_block"],
            func=get_cpu_temp,
            update_interval=2,
            mouse_callbacks={"Button1": lazy.spawn("psensor")},
        ),
        widget.CPU(
            foreground=colors["dark_blue"],
            background=backgrounds["cpu_block"],
            # background="#f5d0f0",
            format="{load_percent}%",
            mouse_callbacks={"Button1": lazy.spawn("psensor")},
            width=45,
        ),
    ]


def ram_block():
    """RAM and Swap information."""
    return [
        widget.TextBox(
            text="﬙",
            foreground=colors["dark_blue"],
            background=backgrounds["ram_block"],
            mouse_callbacks={
                "Button1": lazy.spawn(f"{my_terminal} -e htop")
            },
            fontsize=13,
            font="Iosevka Nerd Font",
        ),
        widget.Memory(
            foreground=colors["dark_blue"],
            background=backgrounds["ram_block"],
            format="{MemUsed:.1f}{mm}/{MemTotal:.0f}{mm}",
            # format="{MemUsed:.1f}{mm}",
            mouse_callbacks={
                "Button1": lazy.spawn(f"{my_terminal} -e htop")
            },
            measure_mem="G",
            padding=5,
        ),
        # widget.Memory(
        #     foreground=colors["black"],
        #     background=backgrounds["ram_block"],
        #     format="{SwapUsed:.0f}{ms}/{SwapTotal:.0f}{ms}",
        #     mouse_callbacks={
        #         "Button1": lazy.spawn(f"{my_terminal} -e htop")
        #     },
        #     measure_swap="G",
        #     padding=5,
        #     fontsize=13,
        #     font="Iosevka Nerd Font",
        # ),
    ]


def volume_block():
    """Volume information."""
    return [
        widget.TextBox(
            text="墳",
            foreground=colors["lighter_blue"],
            background=backgrounds["volume_block"],
            mouse_callbacks={
                "Button1": lazy.spawn("pavucontrol")
            },
            fontsize=13,
            font="Iosevka Nerd Font",
        ),
        widget.Volume(
            fmt="{}",
            foreground=colors["lighter_blue"],
            background=backgrounds["volume_block"],
            mouse_callbacks={
                "Button1": lazy.spawn("pavucontrol")
            },
            padding=5,
        ),
    ]


def clock_block():
    """Clock information."""
    return [
        widget.TextBox(
            text="",
            foreground=colors["lighter_blue"],
            background=backgrounds["clock_block"],
            mouse_callbacks={
                "Button1": lazy.spawn("gnome-calendar")
            },
            fontsize=13,
            font="Iosevka Nerd Font",
        ),
        widget.Clock(
            format="%H:%M %b %d",
            foreground=colors["lighter_blue"],
            background=backgrounds["clock_block"],
            mouse_callbacks={
                "Button1": lazy.spawn("gnome-calendar")
            },
        ),
    ]


def get_backlight_name():
    """Return the first backlight device in sysfs, or None if there is none."""
    try:
        devices = sorted(os.listdir("/sys/class/backlight"))
    except OSError:
        return None
    return devices[0] if devices else None


def has_system_battery():
    """True if a system battery (BAT*), not e.g. a wireless mouse, exists."""
    try:
        supplies = os.listdir("/sys/class/power_supply")
    except OSError:
        return False
    return any(name.startswith("BAT") for name in supplies)


def brightness_block(backlight_name):
    """Brightness information."""
    return [
        widget.TextBox(
            text="\u2600",
            foreground=colors["black"],
            background=backgrounds["brightness_block"],
            fontsize=13,
            font="Iosevka Nerd Font",
        ),
        widget.Backlight(
            fmt="{}",
            backlight_name=backlight_name,
            foreground=colors["black"],
            background=backgrounds["brightness_block"],
            padding=5,
            fontsize=13,
        ),
    ]


def current_layout():
    """Show current Qtile layout."""
    return [
        widget.CurrentLayout(
            mode="icon",
            scale=0.75,
            background=backgrounds["current_layout"],
            custom_icon_paths=[f"{os.environ['HOME']}/.config/qtile/icons/"],
            padding=10,
        ),
    ]


def battery_block():
    """Display battery infromation."""
    return [
        widget.Battery(
            foreground=colors["black"],
            low_foreground=colors["black"],
            background=backgrounds["battery_block"],
            low_background=colors["red"],
            discharge_char="",
            charge_char="",
            full_char="",
            empty_char="",
            low_percentage=0.25,
            format="{char}  {percent:2.1%}",
            update_delay=5,
            padding=13,
        )
    ]


def quick_exit():
    """Shutdown button."""
    return [
        widget.QuickExit(
            default_text="",  # utf8 for the power symbol
            foreground=colors["lighter_blue"],
            # background=backgrounds["quick_exit"],
            padding=10,
            mouse_callbacks={
                "Button1": lazy.spawn(
                    f"{os.environ['HOME']}/.config/rofi/scripts/powermenu"
                )
            },
            fontsize=13,
            font="Iosevka Nerd Font",
        ),
    ]


def get_bar_widgets(primary: bool, laptop: bool) -> bar.Bar:
    """Return an object of bar.Bar."""

    def sep():
        return widget.Sep(linewidth=0, padding=5)

    widgets = [
        widget.TextBox(
            text="",
            foreground=colors["dark_blue"],
            background=colors["light_blue"],
            padding=15,
            mouse_callbacks={
                "Button1": lazy.spawn(
                    f"rofi -theme {os.environ['HOME']}/.config/rofi"
                    + "/themes/arch_logo_combi.rasi "
                    + "-combi-modi window,drun -show combi "
                    + '-display-combi "Apps"'
                )
            },
            fontsize=13,
            font="Iosevka Nerd Font",
            name="Arch Logo",
        ),
        *current_layout(),
        *group_box(),
        sep(),
        *window_name(),
        sep(),
        *audio_block(),
        sep(),
        widget.chord.Chord(
            foreground=colors["dark_blue"],
            background=colors["white"],
            padding=10,
        ),
        widget.Spacer(length=bar.STRETCH),
    ]

    # Systray only on one primary monitor to avoid a systray crash
    if primary:
        widgets += [sep(), *app_block()]

    widgets += [sep(), *update_block()]

    if has_nvidia_gpu():
        widgets += [sep(), *gpu_block()]

    widgets += [sep(), *cpu_block(), sep(), *ram_block()]

    # Only add brightness/battery widgets when the hardware actually exists,
    # otherwise they spam "unable to read status" errors.
    if laptop:
        backlight_name = get_backlight_name()
        if backlight_name:
            widgets += [sep(), *brightness_block(backlight_name)]
        if has_system_battery():
            widgets += [sep(), *battery_block()]

    widgets += [
        sep(),
        *memory_block(),
        sep(),
        *volume_block(),
        sep(),
        *clock_block(),
        sep(),
        *quick_exit(),
    ]

    return bar.Bar(
        widgets,
        25,
        background=colors["dark_blue"],
        opacity=1.0,
        margin=[2, 5, 2, 5],
        border_width=5,
        border_color=colors["dark_blue"],
    )
