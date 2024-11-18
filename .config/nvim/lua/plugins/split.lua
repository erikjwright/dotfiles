return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    {
      "<c-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      mode = { "i", "n", "v" },
      desc = "Move to left window",
    },
    {
      "<c-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      mode = { "i", "n", "v" },
      desc = "Move to bottom window",
    },
    {
      "<c-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      mode = { "i", "n", "v" },
      desc = "Move to top window",
    },
    {
      "<c-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      mode = { "i", "n", "v" },
      desc = "Move to right window",
    },
  },
}
