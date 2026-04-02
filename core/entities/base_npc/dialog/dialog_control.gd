extends Node
class_name DialogControl

var lines=[]
@export var current_block:DialogBlock

func load_from_csv(csv_path:String) -> bool:
	var file=FileAccess.open(csv_path,FileAccess.READ)
	if not file:
		return false
	file.get_csv_line()
	while !file.eof_reached():
		var csv_line=file.get_csv_line()
		#print(csv_line)
		var line:DialogLine=DialogLine.new()
		line.npc_name=csv_line[0]
		line.line_id=csv_line[1]
		line.group=csv_line[2]
		line.level=int(csv_line[3])
		line.line_type=csv_line[4]
		line.text=csv_line[5]
		line.next_group=csv_line[6]
		line.ext=csv_line[7]
		lines.append(line)
	file.close()
	return true
	
func get_lines_by_level(level:int) -> Array[DialogLine]:
	var result:Array[DialogLine]=[]
	for i in range(lines.size()):
		var line:DialogLine=lines[i]
		if line.level==level:
			result.append(line)
	return result

func get_block_by_group(group_name: String) -> DialogBlock:
	var block: DialogBlock = DialogBlock.new()
	block.group=group_name
	for l:DialogLine in lines:
		if l.group == group_name:
			block.level=l.level
			if l.line_type == "npc_line":
				block.npc_line = l
			else:
				block.player_lines.append(l)
	if block.npc_line==null:
		return null
	return block
		
func get_start_dialog_block() -> DialogBlock:
	return get_block_by_group("_start")

func get_dialog_line(block:DialogBlock,index:int) -> DialogLine:
	if not block:
		return null
	if index<0:
		return null
	if block.player_lines.size()<=index:
		return null
	return block.player_lines[index]

func get_current_block() ->DialogBlock:
	return current_block
func set_current_block(block:DialogBlock):
	current_block=block

func answer_current_by_index(index:int) -> DialogBlock:
	return answer_by_index(get_current_block(),index)
		
func answer_by_index(block:DialogBlock,index:int) -> DialogBlock:
	if not block:
		return null
	var line=get_dialog_line(block,index)
	if not line:
		return null
	var next_group:String=line.next_group
	if next_group=="":
		return null
	var answer:DialogBlock=get_block_by_group(next_group)
	return answer
