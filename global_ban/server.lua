-- On joining we need to check them for XSS attempts and VPN / PROXY Checking
--
-- On resource start get the latest ban data? - Or on each player?
--
--
--
--


-- PLAN BELOW ME!
--[[
	Script running process
	----------------------
	Connect to YT servers and check our key is valid!  --> Tell console we are go or no go
	we download latest username expolits --> Tell console we are done or not done
	Check for if there is a new version of this resource! --> Tell console if we are up to date or if we need to update

	On player join, get their status from YT server, then kick if threshold is true --> Tell console and player we kicked them if over threshold (Reason for kick also(depends on cfg file of server))

]]

-- So Script Start-up
-- Check our key is not blank
if Config.Key ~= "" then
	-- Check our key is valid
	PerformHttpRequest("https://gb.yourthought.co.uk/keymaster/check?key="..Config.Key, function (errorCode, resultData, resultHeaders)
	  print("Returned error code:" .. tostring(errorCode))
	  print("Returned data:" .. tostring(resultData))
	  print("Returned result Headers:" .. tostring(resultHeaders))

		if resultData == "Good" then -- update this when backend is setup
			-- Script Update Check
			PerformHttpRequest("https://github.com/Starystars67/Global_Ban_FiveM_Resource/tree/master/global_ban/version.json", function(err, response, headers)
				local data = json.decode(response)

				if Config.CurVersion ~= data.version and tonumber(Config.CurVersion) < tonumber(data.version) then
					print("--------------------------------------------------------------------------")
					print()
					print("\nUpdate Changelog:\n"..data.changelog)
					print("\n--------------------------------------------------------------------------")
				elseif tonumber(Config.CurVersion) > tonumber(data.version) then
					print("Your version of "..resourceName.." seems to be higher than the current version.")
				else
					print(resourceName.." is up to date!")
				end
			end, "GET", "", {version = 'this'})
		end
	end)
end





local maxClients = GetConvarInt('sv_maxclients', 32)

function OnPlayerConnecting(name, setKickReason, deferrals)
	if GetNumPlayerIndices() < maxClients then
		deferrals.defer()
		local identifiers = GetPlayerIdentifiers(source)
		local cname = string.gsub(name, "%s+", "")
		deferrals.update(string.format("Hello %s. Your name is being checked.", name))

		-- Use this for logging and / or banning purposes!
		local ids = ''
		for _, v in pairs(identifiers) do
			local ids = ids..' '..v
		end

		if string.find(cname, "<script") then
			deferrals.done("Your username seems to be fishy...")
			logPlayer(name, ids)
		else
			deferrals.done()
		end
	end
end

-- logging here, you can add your own ban system or what not
function logPlayer(name, ids)
	local string = "Logged User -> "..name..", IDs: "ids.."."
	local file = io.open('resources/'.. GetCurrentResourceName() .. '/Logs/log.txt', "a")
	print(string)
	io.output(file)
	io.write(string)
	io.close(file)
end

AddEventHandler("playerConnecting", OnPlayerConnecting)
