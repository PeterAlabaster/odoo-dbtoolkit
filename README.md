# odoo-dbtoolkit
Source code for helper for common odoo db commands, written in godot game engine.

Just trying to prevent getting RSI inputting database names manually and running long `createdb -T ...` commands.

## Caveats
* Godot produces large binaries, this simple app is around 40Mb exported. I used tkinter previously but it was ugly (shrug)
* If Odoo is running, db drop/backup commands will likely hang
* Debug output is not always that useful

## Roadmap
* Add db `_bak` restorer, which drops the non `_bak` suffixed database, then creates it again using the `_bak` suffixed database
* Add release binaries for linux to save people needing to install godot and download its relevant build templates to run it
