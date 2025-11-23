Config = {}

--▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
--██ ▄▀▄ ██ ▄▄▀████ ▄▄▀█▄ ▄██ ▄▄▄ ██ ▄▄ █ ▄▄▀█▄▄ ▄▄██ ▄▄▀██ ██ 
--██ █ █ ██ ██ ████ ██ ██ ███▄▄▄▀▀██ ▀▀ █ ▀▀ ███ ████ █████ ▄▄ 
--██ ███ ██ ▀▀ ████ ▀▀ █▀ ▀██ ▀▀▀ ██ ████ ██ ███ ████ ▀▀▄██ ██ 
--▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

Config.DispatchDeletion = 600000
Config.Respond = "G"
Config.PrevCall = "LEFT"
Config.NextCall = "RIGHT"


--▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
--███▀▄▀█▀▄▄▀█ ▄▀▄ █ ▄▀▄ █ ▄▄▀█ ▄▄▀█ ▄▀█ ▄▄██
--███ █▀█ ██ █ █▄█ █ █▄█ █ ▀▀ █ ██ █ █ █▄▄▀██
--████▄███▄▄██▄███▄█▄███▄█▄██▄█▄██▄█▄▄██▄▄▄██
--▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

Config.CommandTimeout = 5000
Config.Commands = {
    {command = "911", jobs = {"police", "sheriff"}, anonymous = false, title = "New Call"},
    {command = "911a", jobs = {"police", "sheriff"}, anonymous = true, title = "Anonymous Call"},
    {command = "911ems", jobs = {"ambulance"}, anonymous = false, title = "New Call"},

}



--▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
--█▀▄▄▀█ ▄▄▀█ ▄▄▀██▄██▀▄▀███ ▄▄▀█ ██ █▄ ▄█▄ ▄█▀▄▄▀█ ▄▄▀
--█ ▀▀ █ ▀▀ █ ██ ██ ▄█ █▀███ ▄▄▀█ ██ ██ ███ ██ ██ █ ██ 
--█ ████▄██▄█▄██▄█▄▄▄██▄████▄▄▄▄██▄▄▄██▄███▄███▄▄██▄██▄
--▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

Config.PanicJobs = {"police", "sheriff"}
Config.PanicTitle = "10-99 : Officer needs backup"
Config.PanicCommand = "panicbutton"
Config.PanicTimeout = 5000
Config.PanicKeyBind = "O"



--▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
--█▀▄▄▀█▀▄▄▀█ ███▄██▀▄▀█ ▄▄█████▄█▀▄▄▀█ ▄▄▀█ ▄▄
--█ ▀▀ █ ██ █ ███ ▄█ █▀█ ▄▄█████ █ ██ █ ▄▄▀█▄▄▀
--█ █████▄▄██▄▄█▄▄▄██▄██▄▄▄███ ▀ ██▄▄██▄▄▄▄█▄▄▄
--▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

Config.PoliceJobs = {"police", "sheriff"}
Config.CarjackTitle = "10-16 Vehicle stolen"
Config.CarjackMessage = "^model^ with license plate ^plate^ stolen at ^street^"
Config.CarJackChance = 50

Config.ShootingTitle = {"10-13 Active shooting"}
Config.ShootingMessage = "Active shooting at ^street^"
Config.PlayerShootTimeout = 20
Config.BlacklistShootingZones = {
    {minPos = vector3(1615.8, 4391.12, 0), maxPos = vector3(524.96, 5872.0, 1000)},
}
