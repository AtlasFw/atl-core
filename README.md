# atl-core
The core of Atlas Framework.

## Support
Got stuck while coding or don't know how to use Atlas Framework? Check out the documentation!
* [Documentation](https://atlasfw.live/documentation)
* [Discord](https://discord.gg/ffz84zfaXF)

## Contributing
1. Download the extension called **[StyLua](https://marketplace.visualstudio.com/items?itemName=*JohnnyMorganz*.stylua)**. It will look something like the following if you search for it on the extensions page:
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