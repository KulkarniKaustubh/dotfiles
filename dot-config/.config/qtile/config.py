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


from libqtile import qtile, bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.popup import Popup
import subprocess
import os

# from libqtile.utils import guess_terminal
from bar_widgets import (
    powerline_symbol,
    group_box,
    window_name,
    app_block,
    gpu_block,
    cpu_block,
    memory_block,
    volume_block,
    clock_block,
    current_layout,
    brightness_block,
    battery_block,
    quick_exit,
)

from bar_widgets import colors, backgrounds
from bar_widgets import get_bar_widgets


super_key = "mod4"
alt_key = "mod1"

my_terminal = "alacritty"
my_browser = "google-chrome-stable"

# A list of available commands that can be bound to keys can be found
# at https://docs.qtile.org/en/latest/manual/config/lazy.html


def qtile_keys():
    """Qtile function keys."""
    qtile_keys = [
        Key(
            [super_key, "control"],
            "r",
            lazy.reload_config(),
            desc="Reload the config",
        ),
        Key(
            [super_key, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"
        ),
    ]

    return qtile_keys


def layout_keys():
    """All layout keys."""
    layout_keys = [
        Key([super_key], "h", lazy.layout.left(), desc="Move focus to left"),
        Key([super_key], "l", lazy.layout.right(), desc="Move focus to right"),
        Key([super_key], "j", lazy.layout.down(), desc="Move focus down"),
        Key([super_key], "k", lazy.layout.up(), desc="Move focus up"),
        Key(
            [super_key],
            "g",
            lazy.window.toggle_floating(),
            desc="Toggle floating window",
        ),
        Key(
            [super_key],
            "Tab",
            lazy.layout.next(),
            desc="Move window focus to other window",
        ),
        Key(
            ["control", "shift"],
            "l",
            lazy.screen.next_group(),
            desc="Move to next workspace",
        ),
        Key(
            ["control", "shift"],
            "h",
            lazy.screen.prev_group(),
            desc="Move to prev workspace",
        ),
        Key(
            [alt_key, "control"],
            "Tab",
            lazy.screen.toggle_group(),
            desc="Toggle workspaces",
        ),
        # Move windows between left/right columns or move up/down in current
        # stack.
        # Moving out of range in Columns layout will create new column.
        Key(
            [super_key, "shift"],
            "h",
            lazy.layout.shuffle_left(),
            desc="Move window to the left",
        ),
        Key(
            [super_key, "shift"],
            "l",
            lazy.layout.shuffle_right(),
            desc="Move window to the right",
        ),
        Key(
            [super_key, "shift"],
            "j",
            lazy.layout.shuffle_down(),
            desc="Move window down",
        ),
        Key(
            [super_key, "shift"],
            "k",
            lazy.layout.shuffle_up(),
            desc="Move window up",
        ),
        # Grow windows. If current window is on the edge of screen and
        # direction
        # will be to screen edge - window would shrink.
        Key(
            [super_key, "control"],
            "h",
            lazy.layout.grow_left(),
            desc="Grow window to the left",
        ),
        Key(
            [super_key, "control"],
            "l",
            lazy.layout.grow_right(),
            desc="Grow window to the right",
        ),
        Key(
            [super_key, "control"],
            "j",
            lazy.layout.grow_down(),
            desc="Grow window down",
        ),
        Key(
            [super_key, "control"],
            "k",
            lazy.layout.grow_up(),
            desc="Grow window up",
        ),
        Key(
            [super_key, "control"],
            "n",
            lazy.layout.normalize(),
            desc="Reset all window sizes",
        ),
        # Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key(
            [super_key, "shift"],
            "Return",
            lazy.layout.toggle_split(),
            desc="Toggle between split and unsplit sides of stack",
        ),
        Key(
            [super_key],
            "space",
            lazy.next_layout(),
            desc="Toggle between layouts",
        ),
        Key(
            [super_key, "shift"],
            "space",
            lazy.prev_layout(),
            desc="Toggle between layouts",
        ),
        Key(
            [super_key, "shift"],
            "Tab",
            lazy.layout.rotate(),
            lazy.layout.flip(),
            desc="Switch which side main pane occupies (XmonadTall)",
        ),
        Key([super_key], "q", lazy.window.kill(), desc="Kill focused window"),
        Key(
            [super_key],
            "m",
            lazy.window.toggle_fullscreen(),
            desc="Toggle fullscreen for a window",
        ),
        Key(
            [super_key],
            "period",
            lazy.next_screen(),
            desc="Move focus to next monitor",
        ),
        Key(
            [super_key],
            "comma",
            lazy.prev_screen(),
            desc="Move focus to prev monitor",
        ),
        KeyChord(
            [super_key],
            "w",
            [
                Key(
                    [],
                    "h",
                    lazy.layout.shrink(),
                    lazy.layout.decrease_nmaster(),
                    desc="Shrink window (MonadTall), decrease in master pane",
                ),
                Key(
                    [],
                    "l",
                    lazy.layout.grow(),
                    lazy.layout.increase_nmaster(),
                    desc="Expand window (MonadTall), increase in master pane",
                ),
                Key(
                    [],
                    "n",
                    lazy.layout.reset(),
                    desc="Reset window size ratios",
                ),
                Key(
                    ["control"],
                    "h",
                    lazy.layout.grow_left(),
                    desc="Grow window to the left",
                ),
                Key(
                    ["control"],
                    "l",
                    lazy.layout.grow_right(),
                    desc="Grow window to the right",
                ),
                Key(
                    ["control"],
                    "j",
                    lazy.layout.grow_down(),
                    desc="Grow window down",
                ),
                Key(
                    ["control"],
                    "k",
                    lazy.layout.grow_up(),
                    desc="Grow window up",
                ),
                Key(
                    ["control"],
                    "n",
                    lazy.layout.normalize(),
                    desc="Reset all window sizes",
                ),
            ],
            mode="Window Resize Mode",
        ),
    ]

    return layout_keys


def spawn_keys():
    """All spawn keys for lazy."""
    spawn_keys = [
        Key(
            [super_key],
            "Return",
            lazy.spawn(f"{my_terminal} -e tmux -u"),
            desc="Launch terminal with tmux",
        ),
        Key(
            [super_key],
            "t",
            lazy.spawn(my_terminal),
            desc="Launch terminal",
        ),
        Key(
            [alt_key],
            "Return",
            lazy.spawn(
                f"rofi -theme {os.environ['HOME']}/.config/rofi"
                + "/themes/launchers_colourful_style_7 "
                + '-show run -display-run "Run Command"'
            ),
            # lazy.spawn("dmenu_run -p 'Run: '"),
            desc="Run a command using rofi",
            # desc="Spawn a command using dmenu",
        ),
        Key([super_key], "c", lazy.spawn(my_browser), desc="Launch browser"),
        Key(
            [super_key],
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
        Key([super_key], "d", lazy.spawn("discord"), desc="Launch discord"),
        Key([super_key], "f", lazy.spawn("nautilus"), desc="Launch nautilus"),
        Key(
            [super_key, "shift"],
            "s",
            lazy.spawn("flameshot gui"),
            desc="Screenshot utility",
        ),
        Key(
            [super_key],
            "p",
            lazy.spawn(
                f"rofi -show drun -theme {os.environ['HOME']}/.config/rofi"
                + "/themes/launchers_colourful_style_7"
            ),
            desc="Open menu for all applications",
        ),
        Key(
            [super_key],
            "v",
            lazy.spawn("gnome-calendar"),
            desc="Open calendar",
        ),
        Key(
            [alt_key],
            "Tab",
            lazy.spawn(
                f"rofi -theme {os.environ['HOME']}/.config/rofi"
                + "/themes/launchers_colourful_style_7 "
                + "-combi-modi window,drun -show combi "
                + '-display-combi "Apps"'
            ),
            desc="Display all open tabs and runable applications",
        ),
        Key(
            [alt_key],
            "F4",
            lazy.spawn(
                f"{os.environ['HOME']}/.config/rofi/scripts/menu_powermenu"
            ),
            desc="Open shutdown menu",
        ),
        Key(
            [],
            "XF86AudioMute",
            lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
            desc="Mute audio",
        ),
        Key(
            [],
            "XF86AudioLowerVolume",
            lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
            desc="Reduce volume",
        ),
        Key(
            [],
            "XF86AudioRaiseVolume",
            lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
            desc="Increase volume",
        ),
        Key(
            [],
            "XF86Calculator",
            lazy.spawn("gnome-calculator -m advanced"),
            desc="Open calculator",
        ),
        Key(
            [],
            "XF86MonBrightnessDown",
            lazy.spawn("xbacklight -dec 5"),
            desc="Decrease brightness",
        ),
        Key(
            [],
            "XF86MonBrightnessUp",
            lazy.spawn("xbacklight -inc 5"),
            desc="Increase brightness",
        ),
    ]

    return spawn_keys


workspace_names = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
    "ten": "10",
}

group_names = [
    (
        workspace_names["one"],
        {"layout": "monadtall", "spawn": ["alacritty -e tmux -u"]},
    ),
    (
        workspace_names["two"],
        {"layout": "monadtall", "spawn": ["google-chrome-stable"]},
    ),
    (workspace_names["three"], {"layout": "monadtall"}),
    (workspace_names["four"], {"layout": "monadtall"}),
    (workspace_names["five"], {"layout": "monadtall"}),
    (workspace_names["six"], {"layout": "monadtall"}),
    (workspace_names["seven"], {"layout": "monadtall", "spawn": ["slack"]}),
    (workspace_names["eight"], {"layout": "monadtall", "spawn": ["discord"]}),
    (
        workspace_names["nine"],
        {"layout": "monadtall", "spawn": ["signal-desktop"]},
    ),
    (
        workspace_names["ten"],
        {"layout": "monadtall"},
    ),
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
                [super_key],
                keys[i],
                lazy.group[name].toscreen(screen_number),
                lazy.to_screen(screen_number),
                desc=f"Switch to group {name}",
            )
        )  # Switch to another group
        group_keys.append(
            Key(
                [super_key, "shift"],
                keys[i],
                lazy.window.togroup(name, switch_group=False),
                desc=f"Send active to window to group {name}",
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


def show_keys():
    key_help = ""
    for k in keys:
        mods = ""

        for m in k.modifiers:
            if m == "mod4":
                mods += "Super + "
            else:
                mods += m.capitalize() + " + "

        if len(k.key) > 1:
            mods += k.key.capitalize()
        else:
            mods += k.key

        try:
            desc = k.desc
        except:
            desc = "dummy desc"

        key_help += "{:<30} {}".format(mods, desc + "\n")

    return key_help


pop_obj = Popup(qtile=qtile)

keys.extend(
    [
        # Key(
        #     [super_key, "shift"],
        #     "k",
        #     lazy.spawn(
        #         "sh -c 'echo \""
        #         # + show_keys(keys)
        #         + show_keys()
        #         + '" | rofi -dmenu -i -mesg "Keyboard shortcuts"\''
        #     ),
        #     desc="Print keyboard bindings",
        # )
        # Key(
        #     [super_key, "shift"],
        #     "k",
        #     lazy.spawn(
        #         "alacritty -e sh -c 'echo \""
        #         + show_keys()
        #         + "\" && sleep infinity'"
        #         # + show_keys()
        #         # + '" && sleep infinity'
        #     ),
        #     desc="Print keyboard bindings",
        # )
        # Key(
        #     [super_key, "shift"],
        #     "k",
        #     lazy.function(pop_obj.unhide),
        # )
    ]
)

groups = [Group(name, **kwargs) for name, kwargs in group_names]

layout_defaults = dict(
    border_width=2,
    border_focus="#add8e6",
    margin=5,
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
        fontsize=10,
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
    fontsize=10,
    foreground="#ffffff",
    padding=5,
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


def laptop_monitor_bar():
    """Qtile bar for laptop monitor."""
    return bar.Bar(
        [
            *group_box(),
            *window_name(),
            widget.Sep(linewidth=0, padding=5),
            widget.chord.Chord(
                foreground="#152238",
                background="#ffffff",
                fontsize=10,
                padding=10,
            ),
            widget.Spacer(length=bar.STRETCH),
            *powerline_symbol(
                direction="left",
                foreground="#f5d0f0",
                background="#152238",
            ),
            *cpu_block(),
            *powerline_symbol(
                direction="left",
                foreground="#152238",
                background="#f5d0f0",
            ),
            *powerline_symbol(
                direction="left",
                foreground="#ff8886",
                background="#152238",
            ),
            *volume_block(),
            *powerline_symbol(
                direction="left",
                foreground="#ffaf7a",
                background="#ff8886",
            ),
            *brightness_block(),
            *powerline_symbol(
                direction="left",
                foreground="#90ee90",
                background="#ffaf7a",
            ),
            *battery_block(),
            *powerline_symbol(
                direction="left",
                foreground="#152238",
                background="#90ee90",
            ),
            *powerline_symbol(
                direction="left",
                foreground="#ffff99",
                background="#152238",
            ),
            *clock_block(),
            *powerline_symbol(
                direction="left",
                foreground="#000000",
                background="#ffff99",
            ),
            *app_block(),
            *powerline_symbol(
                direction="left",
                foreground="#ffffff",
                background="#000000",
            ),
            *current_layout(),
            *powerline_symbol(
                direction="left",
                foreground="#dbf0fe",
                background="#ffffff",
            ),
            *quick_exit(),
        ],
        30,
        background="#152238",
        opacity=1.0,
    )


screens = [
    Screen(
        top=get_bar_widgets(primary=True, laptop=False),
    ),
    Screen(
        top=get_bar_widgets(primary=False, laptop=False),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [super_key],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [super_key],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([super_key], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop`
        # to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="gnome-calendar"),  # Calendar app
        Match(wm_class="gnome-calculator"),  # Calculator app
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


# To autostart stuff that would normally be in .xinitrc
@hook.subscribe.startup_once
def start_once():
    """Stuff to autostart with qtile."""
    subprocess.call([f"{os.environ['HOME']}/.config/qtile/autostart.sh"])
