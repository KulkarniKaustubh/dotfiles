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

# from libqtile.utils import guess_terminal


mod = "mod4"
my_terminal = "alacritty"
my_browser = "google-chrome-stable"
# terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
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
    # Move windows between left/right columns or move up/down in current stack.
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
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
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
        [mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"
    ),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
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
    Key([mod], "Return", lazy.spawn(my_terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key(
        [mod, "shift"],
        "Tab",
        lazy.layout.rotate(),
        lazy.layout.flip(),
        desc="Switch which side main pane occupies (XmonadTall)",
    ),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # custom binds from here
    Key(
        [mod],
        "r",
        lazy.spawn("rofi -show run"),
        # lazy.spawn("dmenu_run -p 'Run: '"),
        desc="Run a command using rofi",
        # desc="Spawn a command using dmenu",
    ),
    Key([mod], "c", lazy.spawn(my_browser), desc="Launch browser"),
    Key([mod], "e", lazy.spawn("emacsclient -c"), desc="Launch emacs client"),
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
        [mod],
        "m",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen for a window",
    ),
    # mod1 is Alt
    Key(
        ["mod1"],
        "Tab",
        lazy.spawn("rofi -show window"),
        desc="Open all open windows tabs",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%"),
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%"),
    ),
]

group_names = [
    (
        "one",
        {
            "layout": "monadtall",
            "spawn": ["alacritty", "emacsclient -c -a 'emacs'"],
        },
    ),
    ("two", {"layout": "monadtall", "spawn": ["google-chrome-stable"]}),
    ("three", {"layout": "monadtall"}),
    ("four", {"layout": "monadtall"}),
    ("five", {"layout": "monadtall"}),
    ("six", {"layout": "monadtall"}),
    ("seven", {"layout": "monadtall"}),
    ("eight", {"layout": "monadtall", "spawn": ["discord"]}),
    ("nine", {"layout": "monadtall", "spawn": ["signal-desktop"]}),
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]
for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(
        Key([mod], str(i), lazy.group[name].toscreen())
    )  # Switch to another group
    keys.append(
        Key(
            [mod, "shift"],
            str(i),
            lazy.window.togroup(name, switch_group=False),
        )
    )  # Send current window to another group

layouts = [
    layout.MonadTall(border_width=2, border_focus="#add8e6", margin=10),
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    layout.TreeTab(),
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
                widget.Prompt(),
                widget.WindowName(foreground="#add8e6", max_chars=50),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # widget.TextBox("default config", name="default"),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                widget.Clock(format="%d-%m-%Y %a %I:%M %p"),
                widget.Spacer(length=bar.STRETCH),
                widget.TextBox(
                    text="APPS:",
                    foreground="#add8e6",
                    # background=colors[0],
                    padding=2,
                    fontsize=14,
                ),
                widget.Systray(),
                widget.TextBox(
                    text="| GPU Temp:",
                    foreground="#add8e6",
                    padding=2,
                ),
                widget.NvidiaSensors(
                    foreground="#ffffff",
                    format="{temp}°C",
                ),
                widget.TextBox(
                    text="| CPU:",
                    foreground="#add8e6",
                    padding=2,
                ),
                widget.CPU(
                    foreground="#ffffff",
                    format="{load_percent}%",
                    padding=None,
                ),
                widget.TextBox(
                    text="|",
                    foreground="#add8e6",
                    padding=2,
                ),
                widget.TextBox(
                    text="MEM:",
                    foreground="#add8e6",
                    # background=colors[0],
                    padding=2,
                ),
                widget.Memory(
                    foreground="#ffffff",
                    format="{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            my_terminal + " -e htop"
                        )
                    },
                    padding=None,
                ),
                widget.TextBox(
                    text="|",
                    foreground="#add8e6",
                    padding=2,
                ),
                widget.Volume(
                    foreground="#ffffff",
                    padding=5,
                ),
                widget.TextBox(
                    text="|",
                    foreground="#add8e6",
                    padding=2,
                ),
                widget.CurrentLayout(
                    foreground="#add8e6",
                ),
                # widget.QuickExit(),
            ],
            24,
            # background="add8e6",
            # background="50a6c2",
            background="#152238",
            opacity=1.0,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
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
    ]
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
