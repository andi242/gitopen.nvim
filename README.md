# gitopen.nvim

Check and open the git url in the default web browser.

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim) 

```lua
return {
  'andi242/gitopen.nvim',
  event = "VeryLazy",
  config = function()
    require('gitopen').setup()
  end,
  keys = {
    { '<leader>go', '<cmd>GitOpen<cr>', desc = 'open git url in browser' },
  },
},
```

