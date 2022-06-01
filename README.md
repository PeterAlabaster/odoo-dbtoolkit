# odoo-dbtoolkit
Source code for helper for common odoo db commands for people who switch databases a lot, written in godot game engine.

Very rudimentary using `OS.execute()` to run common commands.

Just trying to prevent getting RSI inputting database names manually and running long `createdb -T ...` commands etc.

Dark theme

![preview-of-toolkit](https://user-images.githubusercontent.com/10167528/171498029-901e87fd-6b74-4062-854e-dd21ecb46e56.png)

## Features
* Database lister with update button, shows all databases on the locally running postgres instance
* Admin password setter, sets all `res.users` passwords (who do not already have a password of `admin`) on the currently selected database to `admin`
* Disable CRON button - sets all active `ir.cron` records on the currently selected database to `False`
* External ID getter - give a model `_name` and a database `ID` on the currently selected database and the _external_ ID will be displayed
* Field getter - give a model `_name` and get all columns available on the model
* Database template backup - create a `_bak` suffixed database using the currently selected database as a template
* Database dropper - drop a database
* Custom query executer

## Caveats
* Godot produces large binaries, this simple app is around 40Mb exported. I used tkinter previously but it was ugly (shrug)
* If Odoo is running, db drop/backup commands will likely hang
* Debug output is not always that useful
* Relies completely on bash commands `psql`, `createdb`, `dropdb` and likely will only work on mac/linux due to this

## Roadmap
* Add db `_bak` restorer, which drops the non `_bak` suffixed database, then creates it again using the `_bak` suffixed database
* Extend field getter to show more useful information
* Add release binaries for linux to save people needing to install godot and download its relevant build templates to run it
