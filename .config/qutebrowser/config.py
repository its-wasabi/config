from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401
import os

config.load_autoconfig(True)

c.fonts.default_family = "Monocraft"
c.fonts.default_size = "11px"

config.bind('<Ctrl-Shift-I>', 'devtools')
config.set("content.local_content_can_access_file_urls", True)
config.set("content.local_content_can_access_remote_urls", True)
with config.pattern('http://localhost:3000') as p:
    p.content.cookies.accept = 'all'

c.content.blocking.method = "both"
c.hints.auto_follow = "unique-match"

c.editor.command = ['kitty', 'nvim', '{file}', '+normal {line}G{column0}l']
c.fileselect.handler = "default"

# Global
c.backend = "webengine"  # Backend to use to display websites.
c.auto_save.session = True  # save session automatically
c.session.lazy_restore = True  # restore session automatically
# Time interval (in milliseconds) between auto-saves of config/cookies/etc.
c.auto_save.interval = 15000
c.downloads.location.prompt = True
# path to default downloads directory
c.downloads.location.directory = "~/Downloads/"
c.completion.web_history.max_items = 10000
c.content.cookies.accept = "no-3rdparty"
# Tabs
# show tabs when there is multiple (hide if only one)
config.set("tabs.show", "multiple")
config.set("tabs.background", False)  # focus on new tabs
c.tabs.select_on_remove = "prev"
# open tabs right under related tabs
config.set("tabs.new_position.related", "next")
# open tabs right under unrelated tabs
config.set("tabs.new_position.unrelated", "last")
# logically stack tabs (if parent tab closes stacked tabs also)
config.set("tabs.new_position.stacking", False)

c.downloads.open_dispatcher = "none"

###############
# Appearance #
###############
# Global
c.colors.webpage.preferred_color_scheme = "dark"
c.scrolling.smooth = True
c.completion.height = "30%"
# Tabs
c.tabs.position = "right"
c.tabs.width = 160
config.set("tabs.title.format", "{private}{audio}{index} {current_title}")
config.set("tabs.title.format_pinned", "{current_title}")

############
# Bindings #
############
# Global
config.bind("<Ctrl-d>", "cmd-run-with-count 15 scroll down")
config.bind("<Ctrl-u>", "cmd-run-with-count 15 scroll up")
config.bind("<Alt-h>", "back")
config.bind("<Alt-l>", "forward")
config.bind("<Alt-e>", "edit-text")  # , mode="insert")
c.aliases = {
    "w": "session-save",
    "q": "close",
    "qa": "quit",
    "wq": "quit --save",
    "wqa": "quit --save",
}
# Tabs
config.bind("J", "tab-next")
config.bind("K", "tab-prev")
config.bind("td", "tab-clone")
config.bind("t1", "tab-focus 1")
config.bind("t2", "tab-focus 2")
config.bind("t3", "tab-focus 3")
config.bind("t4", "tab-focus 4")
config.bind("t5", "tab-focus 5")
config.bind("t6", "tab-focus 6")
config.bind("t7", "tab-focus 7")
config.bind("t8", "tab-focus 8")
config.bind("t9", "tab-focus 9")
config.bind("t0", "tab-focus 10")

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "go": "https://www.google.com/search?q={}",
    "gi": "https://github.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "wi": "https://en.wikipedia.org/wiki/{}",
    "phi": "https://www.phind.com/search?q={}"
}

c.changelog_after_upgrade = "patch"  # minor major

c.colors.completion.category.bg = "#000000"
# TODO: consider changing that color
c.colors.completion.category.border.top = "#808"
c.colors.completion.category.border.bottom = "#f0f"
c.colors.completion.category.fg = "#ffffff"
c.colors.completion.even.bg = "#000000"
c.colors.completion.odd.bg = "#101010"
c.colors.completion.fg = ["#d600c8", "#ffffff", "#ffaf00"]
c.colors.completion.match.fg = "#b3e6e6"
c.colors.completion.item.selected.bg = "#875fff"
c.colors.completion.item.selected.border.bottom = "#875fff"
c.colors.completion.item.selected.border.top = "#875fff"
c.colors.completion.item.selected.fg = "#000000"
c.colors.completion.item.selected.match.fg = "#b3e6e6"
c.colors.completion.scrollbar.bg = "#000000"
c.colors.completion.scrollbar.fg = "#ffffff"

c.colors.contextmenu.disabled.bg = "#000000"
c.colors.contextmenu.disabled.fg = "#666666"
c.colors.contextmenu.menu.bg = "#000000"
c.colors.contextmenu.menu.fg = "#ffffff"
c.colors.contextmenu.selected.bg = "#ffffff"
c.colors.contextmenu.selected.fg = "#000000"

c.colors.downloads.bar.bg = "#000000"
c.colors.downloads.error.bg = "#ff0000"
c.colors.downloads.error.fg = "#ffffff"
c.colors.downloads.start.bg = '#0000AA'
c.colors.downloads.start.fg = "#ffffff"
# TODO: check if it is what you think it is
c.colors.downloads.stop.bg = "#00AA00"
c.colors.downloads.stop.fg = "#FFFFFF"
c.colors.downloads.system.bg = "rgb"
c.colors.downloads.system.fg = "rgb"

# TODO: check what that even is
c.colors.hints.bg = "#000000"
c.colors.hints.fg = "#ffffff"
c.colors.hints.match.fg = "#000000"

c.colors.keyhint.bg = "#00000088"
c.colors.keyhint.fg = "#FFFFFF"
c.colors.keyhint.suffix.fg = "#FF0000"

# Background color of an error message.
# c.colors.messages.error.bg = 'red'
# Border color of an error message.
# c.colors.messages.error.border = '#bb0000'
# Foreground color of an error message.
# c.colors.messages.error.fg = 'white'

# Background color of an info message.
# c.colors.messages.info.bg = 'black'
# Border color of an info message.
# c.colors.messages.info.border = '#333333'
# Foreground color of an info message.
# c.colors.messages.info.fg = 'white'

# Background color of a warning message.
# c.colors.messages.warning.bg = 'darkorange'
# Border color of a warning message.
# c.colors.messages.warning.border = '#d47300'
# Foreground color of a warning message.
# c.colors.messages.warning.fg = 'black'

# Background color for prompts.
# c.colors.prompts.bg = '#444444'

# Border used around UI elements in prompts.
# Type: String
# c.colors.prompts.border = '1px solid gray'

# Foreground color for prompts.
# Type: QssColor
# c.colors.prompts.fg = 'white'

# Background color for the selected item in filename prompts.
# Type: QssColor
# c.colors.prompts.selected.bg = 'grey'

# Foreground color for the selected item in filename prompts.
# Type: QssColor
# c.colors.prompts.selected.fg = 'white'

# Background color of the statusbar in caret mode.
# Type: QssColor
# c.colors.statusbar.caret.bg = 'purple'

# Foreground color of the statusbar in caret mode.
# Type: QssColor
# c.colors.statusbar.caret.fg = 'white'

# Background color of the statusbar in caret mode with a selection.
# Type: QssColor
# c.colors.statusbar.caret.selection.bg = '#a12dff'

# Foreground color of the statusbar in caret mode with a selection.
# Type: QssColor
# c.colors.statusbar.caret.selection.fg = 'white'

# Background color of the statusbar in command mode.
# Type: QssColor
# c.colors.statusbar.command.bg = 'black'

# Foreground color of the statusbar in command mode.
# Type: QssColor
# c.colors.statusbar.command.fg = 'white'

# Background color of the statusbar in private browsing + command mode.
# Type: QssColor
# c.colors.statusbar.command.private.bg = 'darkslategray'

# Foreground color of the statusbar in private browsing + command mode.
# Type: QssColor
# c.colors.statusbar.command.private.fg = 'white'

# Background color of the statusbar in insert mode.
# Type: QssColor
# c.colors.statusbar.insert.bg = 'darkgreen'

# Foreground color of the statusbar in insert mode.
# Type: QssColor
# c.colors.statusbar.insert.fg = 'white'

# Background color of the statusbar.
# Type: QssColor
# c.colors.statusbar.normal.bg = 'black'

# Foreground color of the statusbar.
# Type: QssColor
# c.colors.statusbar.normal.fg = 'white'

# Background color of the statusbar in passthrough mode.
# Type: QssColor
# c.colors.statusbar.passthrough.bg = 'darkblue'

# Foreground color of the statusbar in passthrough mode.
# Type: QssColor
# c.colors.statusbar.passthrough.fg = 'white'

# Background color of the statusbar in private browsing mode.
# Type: QssColor
# c.colors.statusbar.private.bg = '#666666'

# Foreground color of the statusbar in private browsing mode.
# Type: QssColor
# c.colors.statusbar.private.fg = 'white'

# Background color of the progress bar.
# Type: QssColor
# c.colors.statusbar.progress.bg = 'white'

# Foreground color of the URL in the statusbar on error.
# Type: QssColor
# c.colors.statusbar.url.error.fg = 'orange'

# Default foreground color of the URL in the statusbar.
# Type: QssColor
# c.colors.statusbar.url.fg = 'white'

# Foreground color of the URL in the statusbar for hovered links.
# Type: QssColor
# c.colors.statusbar.url.hover.fg = 'aqua'

# Foreground color of the URL in the statusbar on successful load
# (http).
# Type: QssColor
# c.colors.statusbar.url.success.http.fg = 'white'

# Foreground color of the URL in the statusbar on successful load
# (https).
# Type: QssColor
# c.colors.statusbar.url.success.https.fg = 'lime'

# Foreground color of the URL in the statusbar when there's a warning.
# Type: QssColor
# c.colors.statusbar.url.warn.fg = 'yellow'

c.colors.tabs.bar.bg = "#000000"

c.colors.tabs.even.bg = "#000000"
c.colors.tabs.even.fg = "#ffffff"
c.colors.tabs.odd.bg = "#111111"
c.colors.tabs.odd.fg = "#ffffff"

c.colors.tabs.indicator.error = "#ff0000"
c.colors.tabs.indicator.start = "#0000aa"
c.colors.tabs.indicator.stop = "#00aa00"
c.colors.tabs.indicator.system = "rgb"

c.colors.tabs.pinned.even.bg = "#2A2A2A"
c.colors.tabs.pinned.even.fg = "#FFFFFF"
c.colors.tabs.pinned.odd.bg = "#2E2E2E"
c.colors.tabs.pinned.odd.fg = "#FFFFFF"

c.colors.tabs.pinned.selected.even.bg = "#ffffff"
c.colors.tabs.pinned.selected.even.fg = "#000000"
c.colors.tabs.pinned.selected.odd.bg = "#ffffff"
c.colors.tabs.pinned.selected.odd.fg = "#000000"

c.colors.tabs.selected.even.bg = "#afafaf"
c.colors.tabs.selected.even.fg = "#000000"
c.colors.tabs.selected.odd.bg = "#afafaf"
c.colors.tabs.selected.odd.fg = "#000000"


# Background color of tooltips. If set to null, the Qt default is used.
# Type: QssColor
# c.colors.tooltip.bg = None

# Foreground color of tooltips. If set to null, the Qt default is used.
# Type: QssColor
# c.colors.tooltip.fg = None

# Background color for webpages if unset (or empty to use the theme's
# color).
# Type: QtColor
# c.colors.webpage.bg = 'white'

# Which algorithm to use for modifying how colors are rendered with dark
# mode. The `lightness-cielab` value was added with QtWebEngine 5.14 and
# is treated like `lightness-hsl` with older QtWebEngine versions.
# Type: String
# Valid values:
# - lightness-cielab: Modify colors by converting them to CIELAB color space and inverting the L value. Not available with Qt < 5.14.
# - lightness-hsl: Modify colors by converting them to the HSL color space and inverting the lightness (i.e. the "L" in HSL).
# - brightness-rgb: Modify colors by subtracting each of r, g, and b from their maximum value.
# c.colors.webpage.darkmode.algorithm = 'lightness-cielab'

# Contrast for dark mode. This only has an effect when
# `colors.webpage.darkmode.algorithm` is set to `lightness-hsl` or
# `brightness-rgb`.
# Type: Float
# c.colors.webpage.darkmode.contrast = 0.0

# Render all web contents using a dark theme. On QtWebEngine < 6.7, this
# setting requires a restart and does not support URL patterns, only the
# global setting is applied. Example configurations from Chromium's
# `chrome://flags`: - "With simple HSL/CIELAB/RGB-based inversion": Set
# `colors.webpage.darkmode.algorithm` accordingly, and   set
# `colors.webpage.darkmode.policy.images` to `never`.  - "With selective
# image inversion": qutebrowser default settings.
# Type: Bool
c.colors.webpage.darkmode.enabled = False

# Which images to apply dark mode to.
# Type: String
# Valid values:
# - always: Apply dark mode filter to all images.
# - never: Never apply dark mode filter to any images.
# - smart: Apply dark mode based on image content. Not available with Qt 5.15.0.
# - smart-simple: On QtWebEngine 6.6, use a simpler algorithm for smart mode (based on numbers of colors and transparency), rather than an ML-based model. Same as 'smart' on older QtWebEnigne versions.
c.colors.webpage.darkmode.policy.images = "never"
