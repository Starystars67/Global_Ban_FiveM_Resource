local verFile = LoadResourceFile(GetCurrentResourceName(), "version.json")

Config = {}
Config.CurVersion = json.decode(verFile).version
Config.Threshold = 1
Config.Key = "" -- Add your key here in the quotes. Dont have a key? Get one here: Https://global-ban.yourthought.co.uk
Config.ProxyBlock = true
Config.Commands = {}
Config.Commands.Ban = "ban"
Config.Commands.TempBan = "tban"
Config.Commands.Kick = "kick"
