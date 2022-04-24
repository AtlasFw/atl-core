# atl-core
The core of Atlas Framework.

## Support
Got stuck while coding or don't know how to use Atlas Framework? Check out the documentation!
* [Documentation](https://atlasfw.live/documentation)
* [Discord](https://discord.gg/ffz84zfaXF)

## Contributing
1. Download the extension called **[StyLua](https://marketplace.visualstudio.com/items?itemName=*JohnnyMorganz*.stylua)**. It will look something like the following if you search for it on the extensions page

![Extension](https://imgur.com/uFCTMAr.png)

2. Go to VS Code and then to `settings.json`. You also can simply do `Ctrl + Shift + P` and type settings. You will see a file like this:

![Settings](https://imgur.com/6syj1Pl.png)

3. Paste this code. If you have it duplicated an error will appear. Make sure to remove the duplicate.
```lua
  "[lua]": {
    "editor.defaultFormatter": "JohnnyMorganz.stylua"
  },
  "editor.formatOnSave": true
```
4. Once you have done that, you are good to go! Just start coding and when you save your file, it will be formatted.

## License
```
atl-ui

Copyright (C) 2022 Atlas Framework

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
