return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 20,
  height = 10,
  tilewidth = 16,
  tileheight = 16,
  properties = {
    ["cellX"] = "16",
    ["cellY"] = "16",
    ["name"] = "Test Map"
  },
  tilesets = {
    {
      name = "Main",
      firstgid = 1,
      filename = "Main.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../gfx/tileset.png",
      imagewidth = 160,
      imageheight = 256,
      properties = {},
      tiles = {
        {
          id = 23,
          properties = {
            ["type"] = "block"
          }
        },
        {
          id = 144,
          properties = {
            ["animation"] = "3"
          }
        }
      }
    },
    {
      name = "utiltileset",
      firstgid = 161,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../utiltileset.png",
      imagewidth = 64,
      imageheight = 16,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 3",
      x = 0,
      y = 0,
      width = 20,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 39, 39, 39, 39, 39, 39, 39, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 39, 39, 39, 39, 39, 39, 39, 39, 39, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 0, 0, 0, 0, 0, 0,
        0, 35, 0, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 39, 39, 39, 39, 39, 39, 39, 39, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 20,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        1073741830, 0, 0, 0, 0, 0, 0, 0, 0, 3221225493, 22, 22, 22, 51, 31, 51, 51, 31, 1073741845, 0,
        10, 31, 3221225496, 31, 41, 51, 31, 31, 51, 31, 51, 41, 41, 51, 3221225609, 0, 0, 31, 22, 1073741845,
        10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 31, 31,
        10, 76, 72, 145, 76, 0, 34, 0, 0, 45, 0, 0, 2684354594, 0, 0, 0, 0, 0, 0, 31,
        10, 86, 82, 53, 86, 34, 0, 0, 0, 0, 0, 0, 0, 2684354594, 0, 35, 0, 0, 145, 0,
        6, 18, 18, 18, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
        10, 0, 0, 0, 34, 0, 72, 0, 0, 72, 0, 0, 0, 80, 8, 33, 33, 33, 33, 33,
        10, 35, 88, 34, 0, 0, 82, 0, 0, 82, 0, 0, 80, 0, 0, 0, 0, 0, 0, 0,
        10, 70, 87, 2147483735, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0, 0, 0, 0,
        6, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Collisions",
      x = 0,
      y = 0,
      width = 20,
      height = 10,
      visible = true,
      opacity = 0.44,
      properties = {},
      encoding = "lua",
      data = {
        161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161,
        161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 0, 0, 0, 161, 161, 161,
        161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 161, 161, 161,
        161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 161,
        161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        161, 161, 161, 161, 161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 163, 161, 161, 161, 161, 161, 161,
        161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 163, 161, 161, 161, 161, 161, 161, 161,
        161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 163, 161, 161, 161, 161, 161, 161, 161, 161,
        161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161, 161
      }
    },
    {
      type = "objectgroup",
      name = "objectLayer",
      visible = false,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "Thingling",
          type = "Enemy",
          shape = "rectangle",
          x = 256,
          y = 80,
          width = 16,
          height = 16,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
