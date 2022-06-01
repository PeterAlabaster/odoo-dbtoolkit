extends Control
onready var DBLIST = $main/margin/fields/dbsplit/dblist
onready var OUTPUT = $main/margin/fields/outputsplit/output
onready var CUSTOMQUERYINPUT = $main/margin/fields/customquerysplit/TextEdit
onready var FIELDSMODELINPUT = $main/margin/fields/fieldshbox/modelinput
onready var EXTIDMODELINPUT = $main/margin/fields/extidhbox/modelinput
onready var EXTIDIDINPUT = $main/margin/fields/extidhbox/internalidinput

func _ready():
	_on_btnupdatedb_pressed()  # Start by updating db list

func set_output_text(text):
	OUTPUT.text = ""
	OUTPUT.text = text

func execute_bash_command(command, args, set_output=false):
	var output = []
	OS.execute(command, args, true, output)
	if set_output:
		var formatted_output = ""
		if len(output) == 1 and output[0] == "":
			set_output_text("Finished executing: " + command + " " + str(args))
		else:
			for line in output:
				formatted_output += line + "\n"
			print(formatted_output)
			set_output_text(formatted_output)
	else:
		return output

func dbname():
	return DBLIST.get_item_text(DBLIST.selected)

func execute_db_set_output(query):
	execute_bash_command("psql", ["-d", dbname(), "-c", query], true)

func _on_btnupdatedb_pressed():
	var query = "SELECT datname FROM pg_database ORDER BY datname"
	var output = execute_bash_command("psql", ["-d", "postgres", "-t", "-c", query])
	DBLIST.clear()
	# Special handling for splitting out dbnames from output..
	for dbname in output[0].split("\n"):
		DBLIST.add_item(dbname.trim_prefix(" "))

func _on_btnpasswdadmin_pressed():
	execute_db_set_output(
		"UPDATE res_users SET password='admin' WHERE password!='admin'"
	)

func _on_btndisablecron_pressed():
	execute_db_set_output(
		"UPDATE ir_cron SET active=false WHERE active=true"
	)

func _on_btnbackupdb_pressed():
	execute_bash_command("createdb", ["-T", dbname(), dbname() + "_bak"], true)
	_on_btnupdatedb_pressed()

func _on_btndropdb_pressed():
	$dropdbconfirm.dialog_text = "Going to drop " + dbname() + ". Are you sure?"
	$dropdbconfirm.show()

func _on_dropdbconfirm_confirmed():
	execute_bash_command("dropdb", [dbname()], true)
	_on_btnupdatedb_pressed()

func _on_btncustomquery_pressed():
	execute_db_set_output(
		CUSTOMQUERYINPUT.text
	)

func _on_btnoutputclear_pressed():
	set_output_text("")

func _on_btnextid_pressed():
	var query = "SELECT CONCAT(module, '.', name) as external_id from ir_model_data where res_id=" + EXTIDIDINPUT.text + " and model='" + EXTIDMODELINPUT.text + "'"
	execute_db_set_output(query)

func _on_btnfields_pressed():
	var query = "SELECT name, ttype, field_description from ir_model_fields where model_id in (SELECT id from ir_model where model='" + FIELDSMODELINPUT.text + "')"
	execute_db_set_output(query)
