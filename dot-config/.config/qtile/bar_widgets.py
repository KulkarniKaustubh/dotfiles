"""My widget customizations stuff."""

from libqtile import qtile, bar, widget  # , hook
from libqtile.lazy import lazy

# from libqtile.log_utils import logger
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
    "orange": "#ffaf7a",
    "red": "#ff7f7f",
    "yellow": "#ffff99",
    "transparent": "#00000000",
}


backgrounds = {
    "group_box": colors["dark_blue"],
    "window_name": colors["dark_blue"],
    # "gpu_block": colors["green"],
    "gpu_block": "#dbf3fa",
    # "cpu_block": colors["dark_pink"],
    "cpu_block": "#b7e9f7",
    # "ram_block": colors["light_pink"],
    "ram_block": "#92dff3",
    # "volume_block": colors["dark_orange"],
    "volume_block": "#296d98",
    "brightness_block": colors["orange"],
    "battery_block": colors["green"],
    # "clock_block": colors["yellow"],
    "clock_block": "#2f4d7d",
    # "current_layout": colors["lighter_blue"],
    "current_layout": colors["dark_blue"],
    "quick_exit": colors["black"],
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


def get_cpu_temp():
    """Get CPU temperature for AMD CPUs (no core info)."""
    cpu_temp = subprocess.Popen(
        ["sensors | grep \"CPUTIN\" | awk '{print $2}'"],
        stdout=subprocess.PIPE,
        shell=True,
    )
    (out, err) = cpu_temp.communicate()
    # comment to explain the below line
    # the output is like +36.0C, so we split at the dot,
    # take the first half, then remove the sign with [1:]
    temp = out.decode("utf-8").strip("\n").split(".")[0][1:]
    return temp


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
            active="#add8e6",
            # inactive="#add8e680",
            inactive="#78909c",
            highlight_method="line",
            highlight_color=colors["dark_blue"],
            other_current_screen_border="#215578",
            other_screen_border="#215578",
            this_current_screen_border=colors["lighter_blue"],
            this_screen_border=colors["lighter_blue"],
            background=backgrounds["group_box"],
            padding=13,
            fontsize=25,
        ),
    ]


def window_name():
    """Active window name."""
    return [
        # widget.WindowName(
        #     foreground=colors["white"],
        #     background=backgrounds["window_name"],
        #     max_chars=50,
        #     width=bar.CALCULATED,
        #     fontsize=13,
        #     padding=20,
        # ),
        widget.WindowName(
            foreground=colors["white"],
            background=backgrounds["window_name"],
            max_chars=40,
            width=bar.CALCULATED,
            padding=20,
        ),
    ]


def app_block():
    """Open apps."""
    return [
        widget.WidgetBox(
            text_closed="",
            text_open="",
            close_button_location="right",
            fontsize=25,
            widgets=[
                widget.Systray(padding=0),
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
                "Button1": lambda: qtile.cmd_spawn(my_terminal + " -e nvtop")
            },
        ),
        widget.Sep(
            linewidth=0, padding=5, background=backgrounds["gpu_block"]
        ),
        widget.NvidiaSensors(
            foreground="#152238",
            background=backgrounds["gpu_block"],
            format="{temp}°C",
            padding=5,
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
            padding=5,
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
            background="#eff3fd",
            # "#E5F3FD"
            fontsize=15,
            font="Iosevka Nerd Font",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e paru")
            },
        ),
        widget.CheckUpdates(
            display_format="{updates}",
            colour_have_updates=colors["dark_blue"],
            colour_no_updates=colors["dark_blue"],
            background="#eff3fd",
            distro="Arch_paru",
            update_interval=120,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e paru")
            },
        ),
    ]


def memory_block():
    """Disk free space information using `df`."""
    return [
        widget.TextBox(
            text="",
            foreground=colors["dark_blue"],
            background="#e5f3fd",
            fontsize=15,
            font="Iosevka Nerd Font",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    f"{my_terminal}  -e watch df -h /"
                )
            },
        ),
        widget.DF(
            format="{p} {uf}{m} {r:.1f}%",
            visible_on_warn=False,
            foreground=colors["dark_blue"],
            background="#e5f3fd",
            update_interval=120,
            warn_space=100,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
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
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("psensor")},
            fontsize=15,
            font="Iosevka Nerd Font",
        ),
        widget.GenPollText(
            fmt="{}°C",
            foreground=colors["dark_blue"],
            background=backgrounds["cpu_block"],
            func=get_cpu_temp,
            update_interval=2,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("psensor")},
            padding=5,
        ),
        widget.CPU(
            foreground=colors["dark_blue"],
            background=backgrounds["cpu_block"],
            # background="#f5d0f0",
            format="{load_percent}%",
            padding=5,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("psensor")},
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
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            fontsize=15,
            font="Iosevka Nerd Font",
        ),
        widget.Memory(
            foreground=colors["dark_blue"],
            background=backgrounds["ram_block"],
            format="{MemUsed:.1f}{mm}/{MemTotal:.0f}{mm}",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
            },
            measure_mem="G",
            padding=5,
        ),
        # widget.Memory(
        #     foreground=colors["black"],
        #     background=backgrounds["ram_block"],
        #     format="{SwapUsed:.0f}{ms}/{SwapTotal:.0f}{ms}",
        #     mouse_callbacks={
        #         "Button1": lambda: qtile.cmd_spawn(f"{my_terminal} -e htop")
        #     },
        #     measure_swap="G",
        #     padding=5,
        #     fontsize=15,
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
                "Button1": lambda: qtile.cmd_spawn("pavucontrol")
            },
            fontsize=15,
            font="Iosevka Nerd Font",
        ),
        widget.Volume(
            fmt="{}",
            foreground=colors["lighter_blue"],
            background=backgrounds["volume_block"],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("pavucontrol")
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
                "Button1": lambda: qtile.cmd_spawn("gnome-calendar")
            },
            fontsize=15,
            font="Iosevka Nerd Font",
        ),
        widget.Clock(
            format="%I:%M %a %b %d",
            foreground=colors["lighter_blue"],
            background=backgrounds["clock_block"],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("gnome-calendar")
            },
            padding=5,
        ),
    ]


def brightness_block():
    """Brightness information."""
    return [
        widget.TextBox(
            text="\u2600",
            foreground=colors["black"],
            background=backgrounds["brightness_block"],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("pavucontrol")
            },
        ),
        widget.Backlight(
            fmt="{}",
            backlight_name="intel_backlight",
            foreground=colors["black"],
            background=backgrounds["brightness_block"],
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn("pavucontrol")
            },
            padding=5,
            fontsize=13,
        ),
    ]


def current_layout():
    """Show current Qtile layout."""
    return [
        widget.CurrentLayoutIcon(
            scale=0.75,
            background=backgrounds["current_layout"],
            custom_icon_paths=[f"{os.environ['HOME']}/.config/qtile/icons/"],
            padding=13,
        ),
        # widget.CurrentLayout(
        #     foreground=colors["black"],
        #     background=backgrounds["current_layout"],
        #     fontsize=6,
        # ),
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
            format="{char}   {percent:2.1%}",
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
            background=backgrounds["quick_exit"],
            padding=13,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    f"{os.environ['HOME']}/.config/rofi/scripts/"
                    + "menu_powermenu"
                )
            },
            fontsize=15,
            font="Iosevka Nerd Font",
        ),
    ]


def get_bar_widgets(primary: bool, laptop: bool) -> bar.Bar:
    """Return an object of bar.Bar."""
    widgets = [
        widget.TextBox(
            text="",
            foreground=colors["dark_blue"],
            background=colors["light_blue"],
            padding=15,
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(
                    f"rofi -theme {os.environ['HOME']}/.config/rofi"
                    + "/themes/launchers_colourful_style_7 "
                    + "-combi-modi window,drun -show combi "
                    + '-display-combi "Apps"'
                )
            },
            fontsize=15,
            font="Iosevka Nerd Font",
        ),
        *current_layout(),
        *group_box(),
        *window_name(),
        widget.Sep(linewidth=0, padding=5),
        widget.chord.Chord(
            foreground=colors["dark_blue"],
            background=colors["white"],
            fontsize=13,
            padding=13,
        ),
        widget.Spacer(length=bar.STRETCH),
        widget.Sep(linewidth=0, padding=5),
        *update_block(),
        widget.Sep(linewidth=0, padding=5),
        *memory_block(),
        widget.Sep(linewidth=0, padding=5),
        *cpu_block(),
        widget.Sep(linewidth=0, padding=5),
        *ram_block(),
        widget.Sep(linewidth=0, padding=5),
        *volume_block(),
        widget.Sep(linewidth=0, padding=5),
        *clock_block(),
        widget.Sep(linewidth=0, padding=5),
        *quick_exit(),
    ]

    if laptop:
        widgets[19:19] = [
            *brightness_block(),
            *battery_block(),
        ]
    else:
        widgets[19:19] = []

    # Add the GPU block if it exists on the machine
    p1 = subprocess.Popen(
        ["lspci"], stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    p2 = subprocess.Popen(
        ["grep", "-ci", "nvidia"],
        stdin=p1.stdout,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    num_occurences = int(p2.communicate()[0].strip().decode())

    if num_occurences > 0:
        widgets[13:13] = [
            widget.Sep(linewidth=0, padding=5),
            *gpu_block(),
        ]
    else:
        widgets[13:13] = []

    # Add systray only on one primary monitor to avoid systray crash
    if primary:
        widgets[8:8] = [
            widget.Sep(linewidth=0, padding=5),
            *app_block(),
        ]

    return bar.Bar(
        widgets,
        25,
        background=colors["dark_blue"],
        # background=colors["dark_blue"],
        opacity=1.0,
        margin=[2, 5, 2, 5],
        border_width=5,
        border_color=colors["dark_blue"],
    )
