local status, jdtls = pcall(require, 'jdtls')
if status then
  local function jdtls_on_attach(client, bufnr)
    require('lsp_on_attach')(client, bufnr)

    jdtls.setup_dap({ hotcodereplace = 'auto' })
    jdtls.setup.add_commands()
    -- TODO: add other shortcuts?
    -- https://github.com/mfussenegger/dotfiles/blob/89a0acc43ac1d8c2ee475a00b8a448a23b8c1c26/vim/.config/nvim/lua/lsp-config.lua#L90-L95

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }

    function notify_and_run(method)
      print('Executing...')
      vim.schedule(method)
    end

    buf_set_keymap('n', '<Leader>db', '<cmd>lua notify_and_run(require("jdtls").test_class)<CR>', opts)
    buf_set_keymap('n', '<Leader>ca', '<cmd>lua notify_and_run(require("jdtls").code_action)<CR>', opts)
    buf_set_keymap('n', '<Leader>df', '<cmd>lua notify_and_run(require("jdtls").test_nearest_method)<CR>', opts)
  end

  local jdtls_bundles = {vim.env.HOME.."/language-servers/java/extensions/debug.jar"};
  for _, bundle in ipairs(vim.split(vim.fn.glob(vim.env.HOME.."/language-servers/java/extensions/test/extension/server/*.jar"), "\n")) do
    if not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
      table.insert(jdtls_bundles, bundle)
    end
  end

  -- TODO: add the vscode-java-decompiler plugin?

  local extendedClientCapabilities = jdtls.extendedClientCapabilities;
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;

  local config = {
    cmd = {'java-language-server', '--heap-max', '8G'};
    init_options = {
      bundles = jdtls_bundles;
      extendedClientCapabilities = extendedClientCapabilities;
    };
    on_attach = jdtls_on_attach;
  }

  jdtls.start_or_attach(config)
end
