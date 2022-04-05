"""My widget customizations stuff."""

from libqtile import qtile, bar, widget
import subprocess
import os


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
        widget.TextBox(
            text="Apps",
            foreground="#152238",
            background="#dbf0fe",
            padding=10,
            fontsize=10,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    f"rofi -show drun -theme {os.environ['HOME']}/"
                    + ".config/rofi/launchers/colorful/style_7"
                )
            },
        ),
        widget.Systray(padding=5),
    ]


def gpu_block():
    """GPU information."""
    return [
        widget.TextBox(
            text="GPU Temp",
            foreground="#152238",
            background="#90ee90",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=10,
            fontsize=10,
        ),
        widget.NvidiaSensors(
            foreground="#152238",
            background="#defade",
            format="{temp} C",
            padding=3,
            fontsize=10,
        ),
        widget.TextBox(
            text="GPU",
            foreground="#152238",
            background="#90ee90",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=10,
            fontsize=10,
        ),
        widget.GenPollText(
            foreground="#152238",
            background="#defade",
            func=get_gpu_usage,
            update_interval=2,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=3,
            fontsize=10,
        ),
        widget.TextBox(
            text="VRAM",
            foreground="#152238",
            background="#90ee90",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=10,
            fontsize=10,
        ),
        widget.GenPollText(
            foreground="#152238",
            background="#defade",
            func=get_gpu_mem_usage,
            update_interval=2,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
            padding=3,
            fontsize=10,
        ),
    ]


def cpu_block():
    """CPU information."""
    return [
        widget.TextBox(
            text="CPU",
            foreground="#152238",
            background="#f095e4",
            padding=10,
            fontsize=10,
        ),
        widget.CPU(
            foreground="#152238",
            background="#f5d0f0",
            format="{load_percent}%",
            padding=3,
            fontsize=10,
        ),
        widget.TextBox(
            text="RAM",
            foreground="#152238",
            background="#f095e4",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            # background=colors[0],
            padding=10,
            fontsize=10,
        ),
        widget.Memory(
            foreground="#152238",
            background="#f5d0f0",
            format="{MemUsed:.0f}{mm}",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            measure_mem="M",
            padding=3,
            fontsize=10,
        ),
        widget.TextBox(
            text="Swap",
            foreground="#152238",
            background="#f095e4",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            # background=colors[0],
            padding=10,
            fontsize=10,
        ),
        widget.Memory(
            foreground="#152238",
            background="#f5d0f0",
            format="{SwapUsed:.0f}{mm}",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            measure_swap="M",
            padding=3,
            fontsize=10,
        ),
    ]


def volume_block():
    """Volume information."""
    return [
        widget.TextBox(
            text="Vol",
            foreground="#152238",
            background="#fdb35a",
            padding=5,
            fontsize=10,
        ),
        widget.Volume(
            foreground="#152238",
            background="#feddb6",
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
            padding=15,
        ),
    ]


def battery_block():
    """Display battery infromation."""
    return [widget.Battery()]


def quick_exit():
    """Shutdown button."""
    return [
        widget.QuickExit(
            default_text="&#x23FB;",
            fontsize=20,
            foreground="#152238",
            background="#dbf0fe",
            padding=10,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    f"{os.environ['HOME']}/.config/rofi/bin/"
                    + "menu_powermenu"
                )
            },
        ),
    ]
