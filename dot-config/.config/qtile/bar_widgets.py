"""My widget customizations stuff."""

from libqtile import qtile, bar, widget
import subprocess
import os

my_terminal = "alacritty"

colors = {
    "black": "#000000",
    "gray": "#6e6c7e",
    "white": "#ffffff",
    "teal": "#b5e8e0",
    "lighter_blue": "#dbf0fe",
    "light_blue": "#add8e6",
    "dark_blue": "#152238",
    "green": "#90ee90",
    "dark_pink": "#f28fad",
    "light_pink": "#f5d0f0",
    "dark_orange": "#ff8886",
    "yellow": "#ffff99",
    "transparent": "#00000000",
}

backgrounds = {
    "group_box": colors["dark_blue"],
    "window_name": colors["teal"],
    "gpu_block": colors["green"],
    "cpu_block": colors["dark_pink"],
    "memory_block": colors["light_pink"],
    "volume_block": colors["dark_orange"],
    "clock_block": colors["yellow"],
    "current_layout": colors["white"],
    "quick_exit": colors["lighter_blue"],
}


def get_gpu_usage():
    """Get GPU % usage."""
    gpu = subprocess.Popen(
        [
            "nvidia-smi "
            "--query-gpu=utilization.gpu --format=csv,nounits "
            "| "
            "awk '/[0-9]/ {print $1}'"
        ],
        stdout=subprocess.PIPE,
        shell=True,
    )
    (out, err) = gpu.communicate()
    return str(out.decode("utf-8").strip("\n")) + "%"


def get_gpu_mem_usage():
    """Get GPU VRAM usage."""
    gpu = subprocess.Popen(
        [
            "nvidia-smi "
            "--query-gpu=memory.used,memory.total --format=csv,nounits "
            "| "
            "awk '/[0-9]/ {printf \"%dM\",$1}'"
        ],
        stdout=subprocess.PIPE,
        shell=True,
    )
    (out, err) = gpu.communicate()
    return str(out.decode("utf-8").strip("\n"))


def powerline_symbol(direction, foreground, background, fontsize=25):
    """Powerline arrow key symbol."""
    if direction == "left":
        text = ""
    elif direction == "right":
        text = ""
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
            # border="add8e6",
            active="#add8e6",
            inactive="#ffffff",
            highlight_method="line",
            highlight_color="#152238",
            # highlight_color="#152238",
            other_current_screen_border="#215578",
            other_screen_border="#215578",
            this_current_screen_border="#dbf0fe",
            this_screen_border="#dbf0fe",
            border_width=3,
            fontsize=11,
            background=backgrounds["group_box"],
            padding=10,
        ),
    ]


def window_name():
    """Active window name."""
    return [
        widget.WindowName(
            foreground=colors["black"],
            background=backgrounds["window_name"],
            max_chars=50,
            width=bar.CALCULATED,
            fontsize=10,
            padding=20,
        ),
    ]


def app_block():
    """Open apps."""
    return [
        widget.Systray(background=colors["transparent"], padding=5),
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
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
        ),
        widget.Sep(
            linewidth=0, padding=5, background=backgrounds["gpu_block"]
        ),
        widget.NvidiaSensors(
            foreground="#152238",
            background=backgrounds["gpu_block"],
            format="{temp} C",
            padding=10,
            fontsize=10,
        ),
        widget.GenPollText(
            fmt="{}",
            foreground="#152238",
            background=backgrounds["gpu_block"],
            func=get_gpu_usage,
            update_interval=2,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=10,
            fontsize=10,
        ),
        widget.GenPollText(
            fmt="{}",
            foreground="#152238",
            background=backgrounds["gpu_block"],
            func=get_gpu_mem_usage,
            update_interval=2,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=10,
            fontsize=10,
        ),
    ]


def cpu_block():
    """CPU information."""
    return [
        widget.TextBox(
            text="",
            foreground=colors["black"],
            background=backgrounds["cpu_block"],
            fontsize=15,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
        ),
        widget.CPU(
            foreground=colors["black"],
            background=backgrounds["cpu_block"],
            # background="#f5d0f0",
            format="{load_percent}%",
            padding=10,
            fontsize=10,
        ),
    ]


def memory_block():
    """RAM and Swap information."""
    return [
        widget.TextBox(
            text="﬙",
            foreground=colors["black"],
            background=backgrounds["memory_block"],
            fontsize=15,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
        ),
        widget.Memory(
            foreground=colors["black"],
            background=backgrounds["memory_block"],
            format="{MemUsed:.1f}{mm}/{MemTotal:.1f}{mm}",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            measure_mem="G",
            padding=10,
            fontsize=10,
        ),
        widget.Memory(
            foreground=colors["black"],
            background=backgrounds["memory_block"],
            format="{SwapUsed:.1f}{ms}/{SwapTotal:.1f}{ms}",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            measure_swap="G",
            padding=10,
            fontsize=10,
        ),
    ]


def volume_block():
    """Volume information."""
    return [
        widget.TextBox(
            text="墳",
            foreground=colors["black"],
            background=backgrounds["volume_block"],
            fontsize=15,
        ),
        widget.Volume(
            fmt="{}",
            foreground=colors["black"],
            background=backgrounds["volume_block"],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("pavucontrol")
            },
            padding=5,
            fontsize=10,
        ),
    ]


def clock_block():
    """Clock information."""
    return [
        widget.TextBox(
            text="",
            foreground=colors["black"],
            background=backgrounds["clock_block"],
            fontsize=15,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("gnome-calendar")
            },
        ),
        widget.Clock(
            format="%I:%M  %A  %B %d",
            foreground=colors["black"],
            background=backgrounds["clock_block"],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("gnome-calendar")
            },
            fontsize=11,
            padding=10,
        ),
    ]


def brightness_block():
    """Brightness information."""
    return [
        widget.Backlight(
            fmt="Brightness | {}",
            backlight_name="intel_backlight",
            foreground="#152238",
            background="#ffaf7a",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("pavucontrol")
            },
            padding=5,
            fontsize=10,
        ),
    ]


def current_layout():
    """Show current Qtile layout."""
    return [
        widget.CurrentLayoutIcon(
            scale=0.6,
            foreground=colors["black"],
            background=backgrounds["current_layout"],
            custom_icon_paths=[f"{os.environ['HOME']}/.config/qtile/icons/"],
            padding=5,
        ),
        widget.CurrentLayout(
            foreground=colors["black"],
            background=backgrounds["current_layout"],
            fontsize=10,
            padding=5,
        ),
    ]


def battery_block():
    """Display battery infromation."""
    return [
        widget.Battery(
            foreground=colors["black"],
            low_foreground=colors["black"],
            background="#90ee90",
            low_background="#ff7f7f",
            discharge_char="\uF240",
            charge_char="\u26A1 | Charging",
            low_percentage=0.25,
            format="{char} | {percent:2.1%}",
            update_delay=5,
            padding=10,
        )
    ]


def quick_exit():
    """Shutdown button."""
    return [
        widget.QuickExit(
            default_text="&#x23FB;",  # utf8 for the power symbol
            fontsize=15,
            foreground="#152238",
            background=backgrounds["quick_exit"],
            padding=5,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    f"{os.environ['HOME']}/.config/rofi/scripts/"
                    + "menu_powermenu"
                )
            },
        ),
    ]
