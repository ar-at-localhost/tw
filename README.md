# Neovim Theme Watcher

Neovim Theme Watcher (`tw`) is a small plugin that automatically updates your Neovim theme whenever
its configuration changes. It's useful for reacting to system theme changes.

## Why

Neovim has no built-in way to react to system configuration changes, while many other programs do.
This is particularly useful when switching between dark and light themes.

I created this plugin to react to my NixOS configuration changes and automatically switch Neovim
between dark and light themes.

## How

`tw` watches a JSON configuration file for changes. Whenever the file changes, it reads its contents
and updates the theme accordingly.

The configuration file is a simple JSON object with two fields: `theme` and `colorscheme`. You can
specify the path to any valid JSON file containing these fields, and the plugin will work with it.

> [!NOTE]
> `tw` only reads the two fields mentioned above. The configuration file may contain additional fields
> or content.

### Use Cases

- Integrating with your desktop environment to detect theme changes and update the configuration file
accordingly.

## Limitations

`tw` only reacts to file changes and never modifies the configuration file itself. Therefore, it
cannot be considered a self-configuring theme plugin.

> [!WARNING]
> `tw` watches the parent directory of the configuration file for changes. Storing the configuration
> file in a directory containing a large number of files may introduce a performance penalty. Using
> the default configuration path is recommended.

## Installation

Install using any plugin manager. The following example uses Lazy.nvim.

```lua
{
    -- Required dependency
    "ar-at-localhost/yalms",

    -- Theme Watcher
    {
        "ar-at-localhost/tw",
        opts = {
            config = "~/my-theme-file.json", -- Defaults to ~/.config/tw/tw.json
        },
    },
}
```

## Configuration Format

As mentioned earlier, the configuration file requires only two fields.

### theme

Specifies the theme mode: `dark` or `light`. Defaults to `light`. Any value other than `dark` defaults
to `light`.

This field controls Neovim's `background` option.

### colorscheme

Specifies the name of the colorscheme to apply. Defaults to `nil`, leaving the currently active
colorscheme unchanged.

### Example

```json
{
    "theme": "dark",
    "colorscheme": "catppuccin-frappe"
}
```

## License

This program is free software: you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not,
see <https://www.gnu.org/licenses/>.
