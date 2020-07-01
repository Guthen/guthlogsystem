guthlogsystem = guthlogsystem or {}

guthlogsystem.config = {
    --  > Chat command to open the panel
    chatCommand = "!glogs",
    --  > User groups which are allow to see logs
    accessRanks = {
        ["superadmin"] = true,
        ["admin"] = true,
    },
    --  > Number of logs per page
    logsPerPage = 20,
    --  > /!\ Follow is technically configuration, you should avoid touch that if you 
    --      don't know what it does.
    --  > Max pages in bits (see: https://wiki.facepunch.com/gmod/net.WriteUInt)
    --      From 1 to 32, upper value allow greater maximum pages.
    maxPagesInBits = 16,
    --  > Use this if you prefer enter the real maximum value (edit 'MAX_PAGES_IN_DECIMAL')
    --maxPagesInBits = math.ceil( math.log( MAX_PAGES_IN_DECIMAL, 2 ) ),
}

print( "guthlogsystem - 'sh_config.lua' loaded" )
