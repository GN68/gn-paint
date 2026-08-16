extends GridContainer

const HUE_DETAIL: int = 36
const OK_DETAIL: int = 10

@export_enum("RGB","HSV","HSL") var mode: int = 1 : set = set_mode

@onready var button_rgb: Button = $"../HBoxContainer/VBoxContainer/HBoxContainer3/ButtonRGB"
@onready var button_hsv: Button = $"../HBoxContainer/VBoxContainer/HBoxContainer3/ButtonHSV"
@onready var button_hsl: Button = $"../HBoxContainer/VBoxContainer/HBoxContainer3/ButtonHSL"

const COLOR_LABELS = [
	["R","G","B"],
	["H","S","V"],
	["H","S","L"],
]

@onready var label1: Label = $Label1
@onready var label2: Label = $Label2
@onready var label3: Label = $Label3
@onready var label4: Label = $Label4

@onready var slider1: ButtonColorSlider = $ColorSlider1
@onready var slider2: ButtonColorSlider = $ColorSlider2
@onready var slider3: ButtonColorSlider = $ColorSlider3
@onready var slider4: ButtonColorSlider = $ColorSlider4


func _ready() -> void:
	GNp.color_changed.connect(_on_color_changed)
	set_mode(0)

func _on_color_changed(clr1: Color, clr2: Color):
	update_sliders()

func set_mode(new_mode: int):
	if mode != new_mode:
		mode = new_mode
		var t1: Gradient = slider1.texture.gradient
		var t2: Gradient = slider2.texture.gradient
		var t3: Gradient = slider3.texture.gradient
		var lbs = COLOR_LABELS[mode]
		label1.text = lbs[0]
		label2.text = lbs[1]
		label3.text = lbs[2]
		match mode:
			0:
				for i in range(t1.get_point_count()+1):
					t1.remove_point(0)
				for i in range(t2.get_point_count()+1):
					t2.remove_point(0)
				for i in range(t3.get_point_count()+1):
					t3.remove_point(0)
				t1.set_offset(0,0)
				t1.add_point(1,Color.BLACK)
				
				t2.set_offset(0,0)
				t2.add_point(1,Color.BLACK)
				
				t3.set_offset(0,0)
				t3.add_point(1,Color.BLACK)
				
				slider1.length = 255
				slider2.length = 255
				slider3.length = 255
			1:
				for i in range(t1.get_point_count()):
					t1.remove_point(0)
				for i in range(t2.get_point_count()):
					t2.remove_point(0)
				for i in range(t3.get_point_count()):
					t3.remove_point(0)
					
				t1.set_offset(0,0)
				t2.set_offset(0,0)
				t3.set_offset(0,0)
					
				for i in range(HUE_DETAIL):
					var j = float(i)/(HUE_DETAIL-1)
					t1.add_point(j,Color.from_hsv(j,1,1))
				
				t2.add_point(1,Color.BLACK)
				
				t3.add_point(1,Color.BLACK)
				slider1.length = 360
				slider2.length = 100
				slider3.length = 100
			2:
				for i in range(t1.get_point_count()):
					t1.remove_point(0)
				for i in range(t2.get_point_count()):
					t2.remove_point(0)
				for i in range(t3.get_point_count()):
					t3.remove_point(0)
				
				
				t1.set_offset(0,0)
				t2.set_offset(0,0)
				t3.set_offset(0,0)
				
				for i in range(1,OK_DETAIL):
					var j = float(i)/(OK_DETAIL-1)
					t1.add_point(j,Color.BLACK)
				for i in range(1,OK_DETAIL):
					var j = float(i)/(OK_DETAIL-1)
					t2.add_point(j,Color.BLACK)
				for i in range(1,OK_DETAIL):
					var j = float(i)/(OK_DETAIL-1)
					t3.add_point(j,Color.BLACK)
				slider1.length = 360
				slider2.length = 100
				slider3.length = 100
		update_sliders()
	button_rgb.button_pressed = mode != 0
	button_hsv.button_pressed = mode != 1
	button_hsl.button_pressed = mode != 2

func update_sliders():
	var clr := GNp.color_primary
	match mode:
		0:
			slider1.value = clr.r8
			slider2.value = clr.g8
			slider3.value = clr.b8
		1:
			slider1.value = clr.h*360
			slider2.value = clr.s*100
			slider3.value = clr.v*100
		2:
			slider1.value = floor(clr.ok_hsl_h*360)
			slider2.value = clr.ok_hsl_s*100
			slider3.value = clr.ok_hsl_l*100
	slider4.value = clr.a * 100
	update_slider_colors()

func update_slider_colors():
	var clr := GNp.color_primary
	var t1: Gradient = slider1.texture.gradient
	var t2: Gradient = slider2.texture.gradient
	var t3: Gradient = slider3.texture.gradient
	match mode:
		0:
			t1.set_color(0,Color(0,clr.g,clr.b))
			t1.set_color(1,Color(1,clr.g,clr.b))
			
			t2.set_color(0,Color(clr.r,0,clr.b))
			t2.set_color(1,Color(clr.r,1,clr.b))
			
			t3.set_color(0,Color(clr.r,clr.g,0))
			t3.set_color(1,Color(clr.r,clr.g,1))
		1:
			var hcolor = Color.from_hsv(clr.h,1,1)
			
			t2.set_color(0,Color.WHITE)
			t2.set_color(1,hcolor)
			
			t3.set_color(0,Color.BLACK)
			t3.set_color(1,hcolor)
		2:
			for i in range(OK_DETAIL):
				var j = float(i)/(OK_DETAIL-1)
				var col = clr.from_ok_hsl(j,1,0.5)
				t1.set_color(i,col)
			for i in range(OK_DETAIL):
				var p = float(i)/(OK_DETAIL-1)
				t2.set_color(i,clr.from_ok_hsl(clr.ok_hsl_h,p,clr.ok_hsl_l))
			for i in range(OK_DETAIL):
				var p = float(i)/(OK_DETAIL-1)
				t3.set_color(i,clr.from_ok_hsl(clr.ok_hsl_h,clr.ok_hsl_s,p))

func _on_color_slider_1_value_changed(value: int) -> void:
	match mode:
		0:
			GNp.color_primary.r8 = value
		1:
			GNp.color_primary.h = float(value ) / 360
		2:
			GNp.color_primary.ok_hsl_h = float(value) / 360


func _on_color_slider_2_value_changed(value: int) -> void:
	match mode:
		0:
			GNp.color_primary.g8 = value
		1:
			GNp.color_primary.s = float(value ) / 100
		2:
			GNp.color_primary.ok_hsl_s = float(value ) / 100


func _on_color_slider_3_value_changed(value: int) -> void:
	match mode:
		0:
			GNp.color_primary.b8 = value
		1:
			GNp.color_primary.v = float(value) / 100
		2:
			GNp.color_primary.ok_hsl_l = float(value) / 100


func _on_color_slider_4_value_changed(value: int) -> void:
	GNp.color_primary.a = float(value) / 100


func _on_button_rgb_pressed() -> void:
	mode = 0


func _on_button_hsv_pressed() -> void:
	mode = 1


func _on_button_hsl_pressed() -> void:
	mode = 2
