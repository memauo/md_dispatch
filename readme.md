# MD_DISPATCH

- **Free ESX dispatch**
- customisable commands
- setup police jobs and dispatches
- Trigger to create dispatch for jobs that you want

More on **https://md-dev.store**
        **https://discord.gg/PSfvsmXqE6**


# CONFIG

Config.DispatchDeletion = 600000 --**time in ms, when should dispatch delete?**
Config.Respond = "G"
Config.PrevCall = "LEFT"
Config.NextCall = "RIGHT"

Config.CommandTimeout = 5000 --**time in ms** 
Config.Commands = {
    {command = "911", jobs = {"police", "sheriff"}, anonymous = false, title = "New Call"},
    {command = "911a", jobs = {"police", "sheriff"}, anonymous = true, title = "Anonymous Call"},
    {command = "911ems", jobs = {"ambulance"}, anonymous = false, title = "New Call"},
    --**You can add more here, title is the tile with code in dispatch,**
    --**anonymous mode  = if true -> shows player name; if false -> doesnt show players name**

}

Config.PanicJobs = {"police", "sheriff", "ambulance"} --**Who can see and use Panic Button?**   
Config.PanicTitle = "10-99 : Officer needs backup"
Config.PanicCommand = "panicbutton"
Config.PanicTimeout = 5000 --**time in ms, how often can player use panic button?**
Config.PanicKeyBind = "O"

Config.PoliceJobs = {"police", "sheriff"} --**Which Jobs can receive calls from carjack and shooting?**
Config.CarjackTitle = "10-16 Vehicle stolen"
Config.CarjackMessage = "^model^ with license plate ^plate^ stolen at ^street^" --**theres also ^model^ and ^plate^ and ^street^ which you can use so you dont have to use natives to get streetname and more**
Config.CarJackChance = 50

Config.ShootingTitle = {"10-13 Active shooting"}
Config.ShootingMessage = "Active shooting at ^street^"
Config.PlayerShootTimeout = 20 --**If player is shooting without break, every xx miliseconds should come dispatch; f.e. 6000 -> every 6second should come dispatch that player still shoots**
Config.BlacklistShootingZones = {
    {minPos = vector3(1615.8, 4391.12, 0), maxPos = vector3(524.96, 5872.0, 1000)}, --**Now this is Mt.Chilliad; where should be shooting allowed without dispatch creation?**
}


