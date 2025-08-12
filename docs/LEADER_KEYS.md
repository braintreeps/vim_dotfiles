# Leader Keys in Braintree's Neovim Config

If you're arriving at Braintree from elsewhere, chances are you've already got muscle memory for a different `<Leader>` key. Not to worry, Neovim is perfectly capable of supporting multiple `<Leader>` keys at once!

### Why not just remap `<Leader>`?

Here at Braintree, we care a lot about ensuring our development environments are accessible to others that we might be pairing with. You might see reference to this idea as the "lingua franca" for development. With this goal in mind, straying too far from the default mappings in the config is not recommended.

Imagine you let another dev into your `cpair` and you've remapped to a different leader key. Now that dev has effectively lost all their muscle memory for core commands while they're visiting your cpair. Not great situation, right?

### Customzing your `<Leader>` key without breaking default mappings

Let's say you want to make `<Space>` your `<Leader>` key instead of `\`. You can do so without breaking the mappings for `\` with the following:

```lua
-- Map your leader key
vim.g.mapleader = " "
-- Create an alias for the old leader
vim.keymap.set('n', '\\', '<leader>', { remap = true })
-- Plus one more to cover the `\\` mapping
vim.keymap.set('n', '\\\\', '<leader><leader>', { remap = true })
```

You can safely use `<Space>` as leader instead of `\` in your own config while maintaining the same keymaps any other Braintree devs might expect with this strategy!
