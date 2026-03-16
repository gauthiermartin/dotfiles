return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    -- opts = {
    --   flavour = "frappe",
    -- },
    opts = function(_, opts)
      opts.flavour = "mocha"
      return opts
    end,
  },
}
