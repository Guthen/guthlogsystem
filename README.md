# guthlogsystem
Guthen's log system for Garry's Mod

## Panel

![Panel since v1.2.1](https://media.discordapp.net/attachments/610127962981007380/727926900613316638/unknown.png)

![Player Say Section](https://mtxserv.com/forums/attachments/1564836019619-png.18202/)

![guthwhitelistsystem Section](https://mtxserv.com/forums/attachments/1564836069406-png.18203/)

## For users

Install my addon by downloading it and drag and drop it on your `addons` folder of your server.

## For developpers

First of all, you need (on **SERVER SIDE**) to check if `guthlogsystem` exists (if you don't want to have an error if my addon isn't installed on a server) and then create your addons category with `guthlogsystem.addCategory( string name, Color colorInPanel )`.

Then, you can add logs with this function : `guthlogsystem.addLog( string categoryName, string logMsg )` (don't forget to check if `guthlogsystem` exists).

Here it is, you have nothing to do more. The log will be synced on the **CLIENT** with a net.
