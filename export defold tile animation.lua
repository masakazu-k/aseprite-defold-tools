
local sprite = app.activeSprite


local dlg = Dialog()

--- @param f FILE*
--- @param tag any
local function export_animation_tag(f, tag)
  local fps = 10

  local animation_type = "PLAYBACK_LOOP_FORWARD"
  if tag.aniDir == AniDir.FORWARD then
    animation_type = "PLAYBACK_LOOP_FORWARD"
  elseif tag.aniDir == AniDir.REVERSE then
    animation_type = "PLAYBACK_LOOP_BACKWARD"
  elseif tag.aniDir == AniDir.PING_PONG then
    animation_type = "PLAYBACK_LOOP_PINGPONG"
  end

  f:write("animations {\n")
  f:write("  id: \""..tag.name.."\"\n")
  f:write("  start_tile: "..tostring(tag.fromFrame.frameNumber).."\n")
  f:write("  end_tile: "..tostring(tag.toFrame.frameNumber).."\n")
  f:write("  playback: "..animation_type.."\n")
  f:write("  fps: "..tostring(fps).."\n")
  f:write("  flip_horizontal: 0\n")
  f:write("  flip_vertical: 0\n")
  f:write("}\n")
end

--- @param f FILE*
local function export_header(f, sprite, image)
  f:write("image: \""..image.."\"\n")
  f:write("tile_width: "..tostring(sprite.width).."\n")
  f:write("tile_height: "..tostring(sprite.height).."\n")
  f:write("tile_margin: 0\n")
  f:write("tile_spacing: 0\n")
  f:write("collision: \"\"\n")
  f:write("material_tag: \"tile\"\n")
  f:write("collision_groups: \"default\"\n")
end

--- @param f FILE*
local function export_footer(f)
  f:write("extrude_borders: 2\n")
  f:write("inner_padding: 0\n")
end

local function load_image_file(tilesource)
  local f=io.open(tilesource, "r")
  local image = ""
  if f ~= nil then
    local ls = f:read("l")
    image = string.match(ls, " ?image ?: ?\"(.*)\"")
    app.alert(image)
    f:close(f)
  end
  return image
end

local function export(data, sprite)
  local image = load_image_file(data.export_file)
  local f = io.open(data.export_file, "w")

  export_header(f, sprite, image)
  for id, tag in ipairs(sprite.tags) do
    export_animation_tag(f, tag)
  end
  export_footer(f)

  f:close()
end

dlg:file{ id="export_file",
          label="export file(tilesource)",
          title="export file(tilesource)",
          save=true,
          filetypes={ "tilesource" },
          onchange=nil }

dlg:button{ text="Export",
            onclick=function()
                      local data = dlg.data
                      export(data, sprite)
                      dlg:close()
                    end }
dlg:button{ text="Close",
            onclick=function()
                      dlg:close()
                    end }
dlg:show{ wait=true }




