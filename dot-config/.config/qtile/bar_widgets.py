"""My widget customizations stuff."""

from libqtile import qtile, bar, widget
import subprocess
import os

my_terminal = "alacritty"


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
        text = ""
    elif direction == "right":
        text = "▸"
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
            other_current_screen_border="#215578",
            other_screen_border="#215578",
            this_current_screen_border="#dbf0fe",
            this_screen_border="#dbf0fe",
            border_width=3,
            fontsize=11,
        ),
    ]


def window_name():
    """Active window name."""
    return [
        widget.WindowName(
            foreground="#152238",
            background="#dbf0fe",
            max_chars=25,
            width=bar.CALCULATED,
            fontsize=10,
            padding=25,
        ),
    ]


def app_block():
    """Open apps."""
    return [
        widget.Systray(background="#000000", padding=5),
    ]


def gpu_block():
    """GPU information."""
    return [
        widget.NvidiaSensors(
            foreground="#152238",
            background="#90ee90",
            format="GPU Temp | {temp} C",
            padding=5,
            fontsize=10,
        ),
        *powerline_symbol(
            direction="left",
            foreground="#defade",
            background="#90ee90",
        ),
        widget.GenPollText(
            fmt="GPU | {}",
            foreground="#152238",
            background="#defade",
            func=get_gpu_usage,
            update_interval=2,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=5,
            fontsize=10,
        ),
        *powerline_symbol(
            direction="left",
            foreground="#90ee90",
            background="#defade",
        ),
        widget.GenPollText(
            fmt="VRAM | {}",
            foreground="#152238",
            background="#90ee90",
            func=get_gpu_mem_usage,
            update_interval=2,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=5,
            fontsize=10,
        ),
    ]


def cpu_block():
    """CPU information."""
    return [
        widget.CPU(
            foreground="#152238",
            background="#f5d0f0",
            format="CPU | {load_percent}%",
            padding=5,
            fontsize=10,
        ),
        *powerline_symbol(
            direction="left",
            foreground="#f095e4",
            background="#f5d0f0",
        ),
        widget.Memory(
            foreground="#152238",
            background="#f095e4",
            format="RAM | {MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            measure_mem="M",
            padding=5,
            fontsize=10,
        ),
        *powerline_symbol(
            direction="left",
            foreground="#f5d0f0",
            background="#f095e4",
        ),
        widget.Memory(
            foreground="#152238",
            background="#f5d0f0",
            format="Swap | {SwapUsed:.0f}{mm}/{SwapTotal:.0f}{mm}",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            measure_swap="M",
            padding=5,
            fontsize=10,
        ),
    ]


def volume_block():
    """Volume information."""
    return [
        widget.Volume(
            fmt="Vol | {}",
            foreground="#152238",
            background="#ff8886",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("pavucontrol")
            },
            padding=5,
            fontsize=10,
        ),
    ]


def brightness_block():
    """Volume information."""
    return [
        widget.Backlight(
            fmt="Brightness | {}",
            backlight_name="intel_backlight",
            foreground="#152238",
            background="#fffbc8",
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
        widget.CurrentLayout(
            foreground="#152238",
            background="#ffffff",
            fontsize=10,
            padding=5,
        ),
    ]


def battery_block():
    """Display battery infromation."""
    return [
        widget.Battery(
            foreground="#152238",
            low_foreground="#152238",
            background="#90ee90",
            low_background="#ff7f7f",
            discharge_char="\uF240",
            charge_char="\uF240 | Charging",
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
            default_text="&#x23FB;",
            fontsize=15,
            foreground="#152238",
            background="#dbf0fe",
            padding=5,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    f"{os.environ['HOME']}/.config/rofi/scripts/"
                    + "menu_powermenu"
                )
            },
        ),
    ]
