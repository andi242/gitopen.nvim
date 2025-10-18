# gitopen.nvim

Check and open the git url in the default web browser.

The plugin grabs the output of `git ls-remote --get-url` in the current workdir,  
checks if ssh or plain http, reformats if necessary and opens the URL in the browser.  
Should work with any git hoster (codeberg, github, self hosted, ...).

If the current workdir is not a git repo, it only prints a message.

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

## Disclaimer

I can only test this in Linux, so not sure if the code to handle other OS' is correct.
