#! /usr/bin/env lua

--
-- Sample GStreamer application, port of public Vala GStreamer Video
-- Example (http://live.gnome.org/Vala/GStreamerSample)
--

require 'lgi'
local GLib = require 'lgi.GLib'
local Gtk = require 'lgi.Gtk'
local Gst = require 'lgi.Gst'
local GstInterfaces = require 'lgi.GstInterfaces'

Gtk.init()
Gst.init()

local pipeline = Gst.Pipeline.new('mypipeline')
local src = Gst.ElementFactory.make('videotestsrc', 'video')
local sink = Gst.ElementFactory.make('xvimagesink', 'sink')
--pipeline.add(src)
--pipeline.add(sink)
src:link(sink)

local function on_play()
   print(sink)
   print(GstInterfaces.XOverlay(sink))
   GstInterfaces.XOverlay(sink):set_window_handle(0)
   pipeline.set_state(Gst.State.PLAYING)
end

local function on_stop()
   pipeline.set_state(Gst.State.READY)
end

local function create_window()
   local vbox = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0)
   local drawing_area = Gtk.DrawingArea {}
   drawing_area:set_size_request(300, 150)
   vbox:pack_start(drawing_area, true, true, 0)
   local play_button = Gtk.Button.new_from_stock(Gtk.STOCK_MEDIA_PLAY)
   play_button.on_clicked = on_play
   local stop_button = Gtk.Button.new_from_stock(Gtk.STOCK_MEDIA_STOP)
   local quit_button = Gtk.Button.new_from_stock(Gtk.STOCK_QUIT)
   quit_button.on_clicked = Gtk.main_quit
   local button_box = Gtk.ButtonBox.new(Gtk.Orientation.HORIZONTAL)
   button_box:add(play_button)
   button_box:add(stop_button)
   button_box:add(quit_button)
   vbox:pack_start(button_box, false, true, 0)
   return Gtk.Window {
      title = 'Video Player',
      child = vbox,
      on_destroy = Gtk.main_quit
   }
end

create_window():show_all()

Gtk.main()