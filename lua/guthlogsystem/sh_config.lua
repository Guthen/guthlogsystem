guthlogsystem = guthlogsystem or {}

guthlogsystem.config = {
    --  chat command to open the panel
    chatCommand = "!glogs",
    --  user groups which are allow to see logs
    accessRanks = {
        ["superadmin"] = true,
        ["admin"] = true,
    },
    --  number of logs per page
    logsPerPage = 20,

    --  /!\ following is technical configuration, you should avoid touch that if you 
    --      don't know what it does.
    --  maximum number pages (unsigned; in bits) (see: https://wiki.facepunch.com/gmod/net.WriteUInt)
    --      from 1 to 32, upper value allow more pages to be shown.
    maxPagesInBits = 16, --  allow 65535 different pages
    --  use this if you prefer enter the real maximum value (edit 'MAX_PAGES_IN_DECIMAL')
    --maxPagesInBits = math.ceil( math.log( MAX_PAGES_IN_DECIMAL, 2 ) ),

    --  maximum number (unsigned; in bits) of categories allowed to be synchronized
    maxCategoriesInBits = 7, --  allow 127 different categories
}

print( "guthlogsystem - 'sh_config.lua' loaded" )
