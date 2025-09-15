# modified from ignis examples

import datetime
import subprocess

from ignis import gi
import asyncio
from gi.repository import Gtk, Gdk, GLib

from ignis.widgets import Widget
from ignis import utils
from ignis.app import IgnisApp
from ignis.services.audio import AudioService
from ignis.services.backlight import BacklightService
from ignis.services.system_tray import SystemTrayService, SystemTrayItem
from ignis.services.hyprland import HyprlandService
from ignis.services.niri import NiriService
from ignis.services.upower import UPowerService
from ignis.services.notifications import NotificationService
from ignis.services.fetch import FetchService
from ignis.services.mpris import MprisService, MprisPlayer
from ignis.gobject import IgnisGObject
from ignis.menu_model import IgnisMenuModel, IgnisMenuItem, IgnisMenuSeparator

app = IgnisApp.get_default()

app.apply_css(f"{utils.get_current_dir()}/style.scss")


audio = AudioService.get_default()
system_tray = SystemTrayService.get_default()
hyprland = HyprlandService.get_default()
niri = NiriService.get_default()
notifications = NotificationService.get_default()
mpris = MprisService.get_default()
backlight = BacklightService.get_default()
upower = UPowerService.get_default()
fetch = FetchService.get_default()


def hyprland_workspace_button(workspace) -> Widget.Button:
    widget = Widget.Button(
        css_classes=["workspace"],
        on_click=lambda x, id=workspace.id: hyprland.switch_to_workspace(id),
        child=Widget.Label(label=str(workspace.id)),
    )
    if workspace.id == hyprland.active_workspace.id:
        widget.add_css_class("active")
    if workspace.is_urgent:
        widget.add_css_class("urgent")

    return widget


def niri_workspace_button(workspace) -> Widget.Button:
    widget = Widget.Button(
        css_classes=["workspace"],
        on_click=lambda x, id=workspace["idx"]: niri.switch_to_workspace(id),
        child=Widget.Label(label=str(workspace["idx"])),
    )
    if workspace["is_active"]:
        widget.add_css_class("active")

    return widget


def workspace_button(workspace: dict) -> Widget.Button:
    if hyprland.is_available:
        return hyprland_workspace_button(workspace)
    elif niri.is_available:
        return niri_workspace_button(workspace)
    else:
        return Widget.Button()


def hyprland_scroll_workspaces(direction: str) -> None:
    current = hyprland.active_workspace["id"]
    if direction == "up":
        target = current - 1
        hyprland.switch_to_workspace(target)
    else:
        target = current + 1
        if target == 11:
            return
        hyprland.switch_to_workspace(target)


def niri_scroll_workspaces(monitor_name: str, direction: str) -> None:
    current = list(
        filter(
            lambda w: w["is_active"] and w["output"] == monitor_name, niri.workspaces
        )
    )[0]["idx"]
    if direction == "up":
        target = current + 1
        niri.switch_to_workspace(target)
    else:
        target = current - 1
        niri.switch_to_workspace(target)


def scroll_workspaces(direction: str, monitor_name: str = "") -> None:
    if hyprland.is_available:
        hyprland_scroll_workspaces(direction)
    elif niri.is_available:
        niri_scroll_workspaces(monitor_name, direction)
    else:
        pass


def hyprland_workspaces() -> Widget.EventBox:
    return Widget.EventBox(
        on_scroll_up=lambda x: scroll_workspaces("down"),
        on_scroll_down=lambda x: scroll_workspaces("up"),  # change direction because more natural
        css_classes=["workspaces"],
        spacing=5,
        child=hyprland.bind_many(
            ["workspaces", "active_workspace", "urgent_windows"],  # only synced to urgent_workspaces, its value doesn't matter
            transform=lambda value, *_: [workspace_button(i) for i in value],  # *_ denotes many unused variables
        ),
    )


def niri_workspaces(monitor_name: str) -> Widget.EventBox:
    return Widget.EventBox(
        on_scroll_up=lambda x: scroll_workspaces("up", monitor_name),
        on_scroll_down=lambda x: scroll_workspaces("down", monitor_name),
        css_classes=["workspaces"],
        spacing=5,
        child=niri.bind(
            "workspaces",
            transform=lambda value: [
                workspace_button(i) for i in value if i["output"] == monitor_name
            ],
        ),
    )


def workspaces(monitor_name: str) -> Widget.EventBox:
    if hyprland.is_available:
        return hyprland_workspaces()
    elif niri.is_available:
        return niri_workspaces(monitor_name)
    else:
        return Widget.EventBox()


def mpris_title(player: MprisPlayer) -> Widget.Box:
    return Widget.Box(
        spacing=10,
        setup=lambda self: player.connect(
            "closed",
            lambda x: self.unparent(),  # remove widget when player is closed
        ),
        child=[
            Widget.Icon(image="audio-x-generic-symbolic"),
            Widget.Label(
                ellipsize="end",
                max_width_chars=20,
                label=player.bind("title"),
            ),
        ],
    )


def media() -> Widget.Box:
    return Widget.Box(
        spacing=10,
        child=[
            Widget.Label(
                label="No media players",
                visible=mpris.bind("players", lambda value: len(value) == 0),
            )
        ],
        setup=lambda self: mpris.connect(
            "player-added", lambda x, player: self.append(mpris_title(player))
        ),
    )


def hyprland_client_title() -> Widget.Label:
    return Widget.Label(
        ellipsize="end",
        max_width_chars=40,
        label=hyprland.bind(
            "active_window",
            transform=lambda value: value.title
        ),
    )


def niri_client_title(monitor_name) -> Widget.Label:
    return Widget.Label(
        ellipsize="end",
        max_width_chars=40,
        visible=niri.bind("active_output", lambda x: x["name"] == monitor_name),
        label=niri.bind(
            "active_window",
            transform=lambda value: "" if value is None else value.title,
        ),
    )


def client_title(monitor_name: str) -> Widget.Label:
    if hyprland.is_available:
        return hyprland_client_title()
    elif niri.is_available:
        return niri_client_title(monitor_name)
    else:
        return Widget.Label()


def current_notification() -> Widget.Label:
    return Widget.Label(
        ellipsize="end",
        max_width_chars=20,
        label=notifications.bind(
            "notifications", lambda value: value[-1].summary if len(value) > 0 else None
        ),
    )

is_show_date = False
def toggle_show_date(x):
    global is_show_date
    is_show_date = not is_show_date

    x.data_poll.cancel()  # cancel old poll and set up new one to reset it immediately (would be better if poll objects had a "poll now" option)
    poll = utils.Poll(10_000, lambda self: clock_text())
    x.child[0].set_label(poll.bind("output"))
    x.data_poll = poll

def clock_text():
    if not is_show_date:
        #return datetime.datetime.now().strftime("%H:%M:%S")
        return datetime.datetime.now().strftime("%a %H:%M")
    else:
        return datetime.datetime.now().strftime("%Y.%m.%d")


def clock() -> Widget.EventBox:
    # poll for current time every second
    poll = utils.Poll(10_000, lambda self: clock_text())

    clock_label = Widget.Label(
        css_classes=["clock"],
        label = poll.bind("output"),
        )  # couldn't manage to right justify it
    widget = Widget.EventBox(
        css_classes=["clock-box"],
        child = [
            clock_label
            ],
        on_click = toggle_show_date,
    )

    widget.data_poll = poll

    return widget


def stream_volume(stream) -> Widget.Box:
    return Widget.Box(
        child=[
            Widget.EventBox(
                    child = [Widget.Icon(
                        image=stream.bind("icon_name"), style="margin-right: 5px;"
                        )],
                    on_click = lambda x: stream.set_is_muted(not stream.is_muted)
            ),
            Widget.Label(
                label=stream.bind("volume", transform=lambda value: str(value))
            ),
        ]
    )

def brightness_icon() -> Widget.Box:
    return Widget.Box(
        child=[
            Widget.Icon(
                image="weather-clear", # uhh yea thats the sun icon
                style="margin-right: 5px;"
            ),
            Widget.Label(
                label=backlight.bind_many(["brightness", "max_brightness"], transform=lambda brightness, max_brightness: str(int(brightness/max_brightness*100)))
            ),
        ]
    )
    
def setup_icon() -> Widget.EventBox:
    return Widget.EventBox(
        child=[
            Widget.Icon(
                image="emblem-system", style=""  # uhh yea thats the sun icon
            ),
        ],
        on_click=lambda x: subprocess.check_output(".pavucontrol-qt-wrapped", shell=True),
        #style="padding: 3px; border: 1px solid white; border-radius: 8px;"
        style="padding: 3px;"
    )

def capslock_icon(_):
    capslock = subprocess.check_output("cat /sys/class/leds/input*::capslock/brightness", shell=True).decode()[0]  # first letter 0 or 1
    if capslock == "0":
        return "changes-allow"  # unlocked
    elif capslock == "1":
        return "changes-prevent"  # locked
    else:
        return "dialog-error"

def capslock() -> Widget.Box:
    return Widget.Box(
        child=[
            Widget.Icon(
                image=utils.Poll(1_000, capslock_icon).bind("output"),
                style = ""
            ),
        ]
    )

def hyprland_keyboard_layout() -> Widget.EventBox:
    return Widget.EventBox(
        on_click=lambda self: hyprland.switch_kb_layout(),
        child=[Widget.Label(label=hyprland.main_keyboard.bind("active_keymap"))],
    )


def niri_keyboard_layout() -> Widget.EventBox:
    return Widget.EventBox(
        on_click=lambda self: niri.switch_kb_layout(),
        child=[Widget.Label(label=niri.bind("kb_layout"))],
    )


def keyboard_layout() -> Widget.EventBox:
    if hyprland.is_available:
        return hyprland_keyboard_layout()
    elif niri.is_available:
        return niri_keyboard_layout()
    else:
        return Widget.EventBox()


def tray_item(item: SystemTrayItem) -> Widget.Button:
    if item.menu:
        menu = item.menu.copy()
    else:
        menu = None

    return Widget.Button(
        child=Widget.Box(
            child=[
                Widget.Icon(image=item.bind("icon"), pixel_size=24),
                menu,
            ]
        ),
        setup=lambda self: item.connect("removed", lambda x: self.unparent()),
        tooltip_text=item.bind("tooltip"),
        on_click=lambda x: menu.popup() if menu else None,
        on_right_click=lambda x: menu.popup() if menu else None,
        css_classes=["tray-item"],
    )


def tray():
    return Widget.Box(
        setup=lambda self: system_tray.connect(
            "added", lambda x, item: self.append(tray_item(item))
        ),
        spacing=10,
    )


def stream_slider(stream) -> Widget.Scale:
    return Widget.Scale(
        min=0,
        max=100,
        step=1,
        value=stream.bind("volume"),
        on_change=lambda x: stream.set_volume(x.value),
        css_classes=["volume-slider"],  # we will customize style in style.css
    )

def brightness_slider() -> Widget.Scale:
    return Widget.Scale(
        min=0,
        max=backlight.bind("max_brightness"),
        step=1,
        value=backlight.bind("brightness"),
        on_change=lambda x: backlight.set_brightness(x.value),
        css_classes=["volume-slider"],  # we will customize style in style.css
        style = "margin-right: 5px;"
    )

def create_exec_task(cmd: str) -> None:
    # use create_task to run async function in a regular (sync) one
    asyncio.create_task(utils.exec_sh_async(cmd))

def logout() -> None:
    if hyprland.is_available:
        create_exec_task("hyprctl dispatch exit 0")
    elif niri.is_available:
        create_exec_task("niri msg action quit")
    else:
        pass


def power_menu() -> Widget.Button:
    menu = Widget.PopoverMenu (
        model = IgnisMenuModel(
            IgnisMenuItem(
                label="Lock",
                on_activate=lambda x: create_exec_task("swaylock"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Suspend",
                on_activate=lambda x: create_exec_task("systemctl suspend"),
            ),
            IgnisMenuItem(
                label="Hibernate",
                on_activate=lambda x: create_exec_task("systemctl hibernate"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Reboot",
                on_activate=lambda x: create_exec_task("systemctl reboot"),
            ),
            IgnisMenuItem(
                label="Shutdown",
                on_activate=lambda x: create_exec_task("systemctl poweroff"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Logout",
                enabled=hyprland.is_available or niri.is_available,
                on_activate=lambda x: logout(),
            ),
        )
    )
    return Widget.Button(
        child = Widget.Box(
            child = [
                Widget.Icon(
                    #image = fetch.bind("os_logo"),
                    image = "system-shutdown-symbolic",
                    style = "",
                    ),
                menu,
                ]
            ),
        on_click=lambda x: menu.popup(),
    )

def battery() -> Widget.Box:
    return Widget.Box(
            child = [
                Widget.Icon(
                    image=upower.display_device.bind("icon_name"), style="margin-bottom: 1px;"
                ),
                Widget.Label(label=upower.display_device.bind(
                    "percent",
                    transform = lambda value: f"{int(value)}%"
                    )),
                ]
            )

def os_icon() -> Widget.Box:
    return Widget.Box(
        child=[
            Widget.Icon(
                image=fetch.bind("os_logo"),
                style=""
            ),
        ]
    )

def os_info() -> Widget.Box:
    return Widget.Box(
        child = [
            Widget.Label(
                label=fetch.bind_many(
                    ["mem_available", "mem_total"],
                    transform=lambda available, total: f"{(total-available)/1024/1024:.1f}GB / {total/1024/1024:.1f}GB"
                    ),
                style = "margin-right: 12px;"
                ),
            Widget.Label(
                label=fetch.bind(
                    "cpu_temp",
                    transform=lambda value: f"{int(value)}°C"
                    ),
                ),
            ]
    )

def left(monitor_name: str) -> Widget.Box:
    return Widget.Box(
        child=[
            os_icon(),
            os_info(),
            Widget.Separator(vertical=True, css_classes=["middle-separator"]),
            stream_volume(audio.microphone),
            stream_slider(audio.microphone),
            stream_volume(audio.speaker),
            stream_slider(audio.speaker),
            setup_icon(),
            Widget.Separator(vertical=True, css_classes=["middle-separator"]),
            client_title(monitor_name),
            ],
        spacing=10
    )


def center(monitor_name) -> Widget.Box:
    return Widget.Box(
        child=[
            workspaces(monitor_name),
            #current_notification(),
            #Widget.Separator(vertical=True, css_classes=["middle-separator"]),
            #media(),
        ],
        spacing=10,
    )


def right() -> Widget.Box:
    return Widget.Box(
        child=[
            tray(),
            Widget.Separator(vertical=True, css_classes=["middle-separator"]),
            capslock(),
            keyboard_layout(),
            brightness_icon(),
            brightness_slider(),
            battery(),
            Widget.Separator(vertical=True, css_classes=["middle-separator"]),
            clock(),
            Widget.Separator(vertical=True, css_classes=["middle-separator"]),
            power_menu(),
        ],
        spacing=10,
    )


def bar(monitor_id: int = 0) -> Widget.Window:
    monitor_name = utils.get_monitor(monitor_id).get_connector()  # type: ignore
    return Widget.Window(
        namespace=f"ignis_bar_{monitor_id}",
        monitor=monitor_id,
        anchor=["left", "top", "right"],
        exclusivity="exclusive",
        child=Widget.CenterBox(
            css_classes=["bar"],
            start_widget=left(monitor_name),  # type: ignore
            center_widget=center(monitor_name),
            end_widget=right(),
        ),
    )


# this will display bar on all monitors
for i in range(utils.get_n_monitors()):
    bar(i)
