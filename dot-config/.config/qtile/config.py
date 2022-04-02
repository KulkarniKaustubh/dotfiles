"""My configuration for the Qtile Tiling Window Manager."""
#
# -----------
#  _  ___  __
# | |/ / |/ /
# | ' /| ' /
# | . \| . \
# |_|\_\_|\_\
#
# -----------
#
# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401


from libqtile import qtile, bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import subprocess

# from libqtile.utils import guess_terminal


mod = "mod4"
my_terminal = "alacritty"
my_browser = "google-chrome-stable"

# A list of available commands that can be bound to keys can be found
# at https://docs.qtile.org/en/latest/manual/config/lazy.html


def qtile_keys():
    """Qtile function keys."""
    qtile_keys = [
        Key(
            [mod, "control"],
            "r",
            lazy.reload_config(),
            desc="Reload the config",
        ),
        Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    ]

    return qtile_keys


def layout_keys():
    """All layout keys."""
    layout_keys = [
        Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
        Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
        Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
        Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
        Key(
            [mod],
            "Tab",
            lazy.layout.next(),
            desc="Move window focus to other window",
        ),
        # Move windows between left/right columns or move up/down in current
        # stack.
        # Moving out of range in Columns layout will create new column.
        Key(
            [mod, "shift"],
            "h",
            lazy.layout.shuffle_left(),
            desc="Move window to the left",
        ),
        Key(
            [mod, "shift"],
            "l",
            lazy.layout.shuffle_right(),
            desc="Move window to the right",
        ),
        Key(
            [mod, "shift"],
            "j",
            lazy.layout.shuffle_down(),
            desc="Move window down",
        ),
        Key(
            [mod, "shift"],
            "k",
            lazy.layout.shuffle_up(),
            desc="Move window up",
        ),
        # Grow windows. If current window is on the edge of screen and
        # direction
        # will be to screen edge - window would shrink.
        Key(
            [mod, "control"],
            "h",
            lazy.layout.grow_left(),
            desc="Grow window to the left",
        ),
        Key(
            [mod, "control"],
            "l",
            lazy.layout.grow_right(),
            desc="Grow window to the right",
        ),
        Key(
            [mod, "control"],
            "j",
            lazy.layout.grow_down(),
            desc="Grow window down",
        ),
        Key(
            [mod, "control"],
            "k",
            lazy.layout.grow_up(),
            desc="Grow window up",
        ),
        Key(
            [mod, "control"],
            "n",
            lazy.layout.normalize(),
            desc="Reset all window sizes",
        ),
        # Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key(
            [mod, "shift"],
            "Return",
            lazy.layout.toggle_split(),
            desc="Toggle between split and unsplit sides of stack",
        ),
        Key(
            [mod],
            "space",
            lazy.next_layout(),
            desc="Toggle between layouts",
        ),
        Key(
            [mod, "shift"],
            "space",
            lazy.prev_layout(),
            desc="Toggle between layouts",
        ),
        Key(
            [mod, "shift"],
            "Tab",
            lazy.layout.rotate(),
            lazy.layout.flip(),
            desc="Switch which side main pane occupies (XmonadTall)",
        ),
        Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
        Key(
            [mod],
            "m",
            lazy.window.toggle_fullscreen(),
            desc="Toggle fullscreen for a window",
        ),
        Key(
            [mod],
            "period",
            lazy.next_screen(),
            desc="Move focus to next monitor",
        ),
        Key(
            [mod],
            "comma",
            lazy.prev_screen(),
            desc="Move focus to prev monitor",
        ),
    ]

    return layout_keys


def spawn_keys():
    """All spawn keys for lazy."""
    spawn_keys = [
        Key(
            [mod],
            "Return",
            lazy.spawn(my_terminal),
            desc="Launch terminal",
        ),
        Key(
            [mod],
            "t",
            lazy.spawn(f"{my_terminal} -e tmux -u"),
            desc="Launch terminal with tmux",
        ),
        Key(
            [mod],
            "r",
            lazy.spawn("rofi -show run"),
            # lazy.spawn("dmenu_run -p 'Run: '"),
            desc="Run a command using rofi",
            # desc="Spawn a command using dmenu",
        ),
        Key([mod], "c", lazy.spawn(my_browser), desc="Launch browser"),
        Key(
            [mod],
            "e",
            lazy.spawn("emacsclient -c"),
            desc="Launch emacs client",
        ),
        Key(
            ["control", "shift"],
            "e",
            lazy.spawn("/usr/bin/emacs"),
            desc="Launch emacs",
        ),
        Key([mod], "d", lazy.spawn("discord"), desc="Launch discord"),
        Key([mod], "f", lazy.spawn("nautilus"), desc="Launch nautilus"),
        Key(
            [mod, "shift"],
            "s",
            lazy.spawn("flameshot gui"),
            desc="Screenshot utility",
        ),
        Key(
            ["mod1"],  # mod1 is Alt
            "Tab",
            lazy.spawn("rofi -show window"),
            desc="Open all open windows tabs",
        ),
        Key(
            [],
            "XF86AudioLowerVolume",
            lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        ),
        Key(
            [],
            "XF86AudioRaiseVolume",
            lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        ),
    ]

    return spawn_keys


group_names = [
    ("one", {"layout": "monadtall", "spawn": ["alacritty"]}),
    ("two", {"layout": "monadtall", "spawn": ["google-chrome-stable"]}),
    ("three", {"layout": "monadtall"}),
    ("four", {"layout": "monadtall"}),
    ("five", {"layout": "monadtall"}),
    ("six", {"layout": "monadtall"}),
    ("seven", {"layout": "monadtall"}),
    ("eight", {"layout": "monadtall", "spawn": ["discord"]}),
    ("nine", {"layout": "monadtall", "spawn": ["signal-desktop"]}),
    ("ten", {"layout": "monadtall"}),
]

keys_screen_0 = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
keys_screen_1 = [
    "KP_End",
    "KP_Down",
    "KP_Page_Down",
    "KP_Left",
    "KP_Begin",
    "KP_Right",
    "KP_Home",
    "KP_Up",
    "KP_Page_Up",
    "KP_Insert",
]


def group_keys(group_names, keys, screen_number):
    """Keys to access screen groups."""
    group_keys = []
    for i, (name, kwargs) in enumerate(group_names):
        group_keys.append(
            Key(
                [mod],
                keys[i],
                lazy.group[name].toscreen(screen_number),
                lazy.to_screen(screen_number),
            )
        )  # Switch to another group
        group_keys.append(
            Key(
                [mod, "shift"],
                keys[i],
                lazy.window.togroup(name, switch_group=False),
            )
        )

    return group_keys


keys = [
    *qtile_keys(),
    *layout_keys(),
    *spawn_keys(),
    *group_keys(group_names, keys=keys_screen_0, screen_number=0),
    *group_keys(group_names, keys=keys_screen_1, screen_number=1),
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

layout_defaults = dict(
    border_width=2,
    border_focus="#add8e6",
    margin=10,
)
layouts = [
    layout.MonadTall(**layout_defaults),
    layout.TreeTab(
        active_bg="#add8e6",
        active_fg="#000000",
        inactive_bg="#152238",
        inactive_fg="#ffffff",
        padding_left=0,
        padding_x=0,
        padding_y=5,
        section_top=10,
        section_bottom=20,
        level_shift=8,
        vspace=3,
        panel_width=200,
        **layout_defaults,
    ),
    layout.Columns(
        border_focus_stack=["#d75f5f", "#8f3d3d"], **layout_defaults
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    foreground="#ffffff",
    # foreground="000000",
    padding=3,
)
extension_defaults = widget_defaults.copy()


def pipe(
    direction="left",
    fontsize=35,
    foreground="#add8e6",
    background=None,
    **kwargs,
):
    """Render a pipe symbol in the qtile bar."""
    if direction == "straight":
        text = "|"
    elif direction == "left":
        text = "\\"
    elif direction == "right":
        text = "/"

    return [
        widget.TextBox(
            text=text,
            foreground=foreground,
            background=background,
            fontsize=fontsize,
            **kwargs,
        ),
    ]


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
    return str(out.decode("utf-8").strip("\n")) + "% "


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


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    # border="add8e6",
                    active="#add8e6",
                    inactive="#ffffff",
                    highlight_method="line",
                    highlight_color="#152238",
                    border_width=3,
                ),
                widget.WindowName(foreground="#add8e6", max_chars=50),
                widget.Clock(format="%d-%m-%Y %a %I:%M %p"),
                widget.Spacer(length=bar.STRETCH),
                *pipe(),
                widget.TextBox(
                    text="Apps:",
                    foreground="#add8e6",
                    fontsize=10,
                ),
                widget.Systray(
                    iconsize=5,
                ),
                *pipe(),
                widget.TextBox(
                    text="GPU Temp:",
                    foreground="#add8e6",
                    padding=2,
                    fontsize=10,
                ),
                widget.NvidiaSensors(
                    foreground="#ffffff",
                    format="{temp} C",
                    fontsize=10,
                ),
                widget.TextBox(
                    text="GPU: ",
                    foreground="#add8e6",
                    padding=2,
                    fontsize=10,
                ),
                widget.GenPollText(
                    func=get_gpu_usage,
                    update_interval=2,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            my_terminal + " -e nvtop"
                        )
                    },
                    padding=0,
                    fontsize=10,
                ),
                widget.TextBox(
                    text="VRAM: ",
                    foreground="#add8e6",
                    padding=2,
                    fontsize=10,
                ),
                widget.GenPollText(
                    func=get_gpu_mem_usage,
                    update_interval=2,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            my_terminal + " -e nvtop"
                        )
                    },
                    padding=0,
                    fontsize=10,
                ),
                *pipe(),
                widget.TextBox(
                    text="CPU:",
                    foreground="#add8e6",
                    padding=2,
                    fontsize=10,
                ),
                widget.CPU(
                    foreground="#ffffff",
                    format="{load_percent}%",
                    padding=None,
                    fontsize=10,
                ),
                widget.TextBox(
                    text="RAM:",
                    foreground="#add8e6",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            f"{my_terminal} -e htop"
                        )
                    },
                    # background=colors[0],
                    padding=2,
                    fontsize=10,
                ),
                widget.Memory(
                    foreground="#ffffff",
                    format="{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            f"{my_terminal} -e htop"
                        )
                    },
                    measure_mem="M",
                    padding=None,
                    fontsize=10,
                ),
                widget.TextBox(
                    text="Swap:",
                    foreground="#add8e6",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            f"{my_terminal} -e htop"
                        )
                    },
                    # background=colors[0],
                    padding=2,
                    fontsize=10,
                ),
                widget.Memory(
                    foreground="#ffffff",
                    format="{SwapUsed:.0f}{mm}/{SwapTotal:.0f}{mm}",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            f"{my_terminal} -e htop"
                        )
                    },
                    measure_swap="M",
                    padding=None,
                    fontsize=10,
                ),
                *pipe(),
                widget.TextBox(
                    text="Vol:",
                    foreground="#add8e6",
                    padding=2,
                    fontsize=10,
                ),
                widget.Volume(
                    foreground="#ffffff",
                    padding=5,
                    fontsize=10,
                ),
                *pipe(),
                widget.CurrentLayout(
                    foreground="#add8e6",
                    fontsize=10,
                ),
                # widget.QuickExit(),
            ],
            24,
            background="#152238",
            opacity=1.0,
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    # border="add8e6",
                    active="#add8e6",
                    inactive="#ffffff",
                    highlight_method="line",
                    highlight_color="#152238",
                    border_width=3,
                    fontsize=11,
                ),
                widget.Prompt(),
                widget.WindowName(
                    foreground="#add8e6", fontsize=11, max_chars=20
                ),
                widget.Clock(format="%d-%m-%Y %a %I:%M %p"),
                widget.Spacer(length=bar.STRETCH),
                *pipe(),
                widget.TextBox(
                    text="GPU: ",
                    foreground="#add8e6",
                    padding=2,
                    fontsize=10,
                ),
                widget.GenPollText(
                    func=get_gpu_usage,
                    update_interval=2,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            my_terminal + " -e nvtop"
                        )
                    },
                    padding=0,
                    fontsize=10,
                ),
                widget.TextBox(
                    text="VRAM: ",
                    foreground="#add8e6",
                    padding=2,
                    fontsize=10,
                ),
                widget.GenPollText(
                    func=get_gpu_mem_usage,
                    update_interval=2,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            my_terminal + " -e nvtop"
                        )
                    },
                    padding=0,
                    fontsize=10,
                ),
                *pipe(),
                widget.TextBox(
                    text="RAM:",
                    foreground="#add8e6",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            f"{my_terminal} -e htop"
                        )
                    },
                    # background=colors[0],
                    padding=2,
                    fontsize=10,
                ),
                widget.Memory(
                    foreground="#ffffff",
                    format="{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            f"{my_terminal} -e htop"
                        )
                    },
                    measure_mem="M",
                    padding=None,
                    fontsize=10,
                ),
                *pipe(),
                widget.TextBox(
                    text="Vol:",
                    foreground="#add8e6",
                    padding=2,
                    fontsize=10,
                ),
                widget.Volume(
                    foreground="#ffffff",
                    padding=5,
                    fontsize=10,
                ),
                *pipe(),
                widget.CurrentLayout(
                    foreground="#add8e6",
                    fontsize=10,
                ),
            ],
            24,
            background="#152238",
            opacity=1.0,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    **layout_defaults,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
