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
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../tileset.png",
      imagewidth = 160,
      imageheight = 176,
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
      firstgid = 111,
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
        1073741861, 0, 0, 0, 0, 0, 0, 0, 0, 3221225493, 99, 99, 99, 50, 31, 50, 60, 31, 1073741845, 0,
        10, 31, 3221225496, 31, 50, 60, 31, 31, 60, 31, 60, 50, 60, 60, 0, 0, 0, 31, 99, 1073741845,
        10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 31, 31,
        10, 91, 0, 43, 2147483739, 0, 34, 0, 0, 45, 0, 0, 2684354594, 0, 0, 0, 0, 0, 0, 31,
        10, 86, 2147483739, 53, 86, 34, 0, 0, 0, 0, 0, 0, 0, 2684354594, 0, 35, 0, 0, 43, 0,
        10, 74, 74, 74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 53, 0,
        10, 0, 0, 0, 34, 0, 0, 0, 0, 0, 0, 0, 0, 80, 8, 33, 33, 33, 33, 33,
        10, 35, 88, 34, 0, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0, 0, 0,
        10, 0, 87, 2147483735, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0, 0, 0, 0,
        37, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0, 0, 0, 111, 0, 0,
        111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 111, 111, 111,
        111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 111,
        111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        111, 111, 111, 111, 111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 113, 111, 111, 111, 111, 111, 111,
        111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 113, 111, 111, 0, 0, 0, 0, 0,
        111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 113, 111, 111, 0, 0, 0, 0, 0, 0,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0, 0, 0, 0, 0, 0, 0, 0
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