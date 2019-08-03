# guthlogsystem
Guthen's log system for Garry's Mod

## For users

Install my addon by downloading it and drag and drop it on your `addons` folder of your server.

## For developpers

First of all, you need (on **SERVER SIDE**) to check if `guthlogsystem` exists (if you don't want to have an error if my addon isn't installed on a server) and then create your addons category with `guthlogsystem.addCategory( string name, Color colorInPanel )`.

Then, you can add logs with this function : `guthlogsystem.addLog( string categoryName, string logMsg )` (don't forget to check if `guthlogsystem` exists).

Here it is, you have nothing to do more. The log will be synced on the **CLIENT** with a net.
