return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 20,
  height = 10,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "Main",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../tileset.png",
      imagewidth = 160,
      imageheight = 144,
      properties = {},
      tiles = {
        {
          id = 23,
          properties = {
            ["type"] = "block"
          }
        }
      }
    },
    {
      name = "utiltileset",
      firstgid = 91,
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
        0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0,
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 31, 31, 31, 31, 31, 31,
        0, 0, 3221225496, 31, 0, 31, 31, 31, 31, 31, 31, 31, 31, 31, 36, 36, 36, 36, 36, 36,
        3221225496, 21, 0, 31, 0, 31, 3221225504, 3221225505, 3221225505, 3221225505, 3221225505, 3221225505, 3221225505, 1610612768, 17, 17, 0, 0, 0, 0,
        0, 0, 0, 31, 0, 31, 2684354593, 0, 0, 45, 0, 0, 0, 1610612769, 0, 0, 0, 0, 0, 0,
        0, 43, 0, 31, 31, 31, 2684354593, 0, 0, 0, 0, 0, 0, 2684354594, 0, 35, 0, 0, 43, 0,
        0, 53, 0, 0, 35, 0, 34, 0, 0, 0, 42, 0, 46, 0, 2684354594, 0, 0, 0, 53, 0,
        24, 25, 0, 0, 0, 34, 0, 0, 44, 0, 52, 0, 0, 14, 33, 33, 33, 33, 33, 33,
        0, 0, 24, 31, 31, 31, 33, 33, 33, 33, 33, 33, 33, 32, 21, 0, 31, 0, 0, 0,
        0, 0, 0, 0, 0, 31, 31, 31, 31, 31, 31, 31, 31, 31, 0, 0, 31, 17, 17, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 0, 0, 0
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
      opacity = 0.79,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 91, 91, 91, 91, 91, 91, 91,
        0, 0, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 0, 0, 0, 0, 0, 0,
        91, 91, 0, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 92, 92, 0, 0, 0, 0,
        0, 0, 0, 91, 91, 91, 91, 0, 0, 0, 0, 0, 0, 91, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 91, 91, 91, 91, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        91, 94, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 93, 91, 91, 91, 91, 91, 91,
        0, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 0, 91, 0, 0, 0,
        0, 0, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 0, 0, 91, 92, 92, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 91, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "objectLayer",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "2",
          type = "Exit",
          shape = "rectangle",
          x = 0,
          y = 48,
          width = 16,
          height = 48,
          visible = true,
          properties = {}
        },
        {
          name = "3",
          type = "Exit",
          shape = "rectangle",
          x = 304,
          y = 16,
          width = 16,
          height = 80,
          visible = true,
          properties = {}
        },
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
