-- requires:
-- $ mise install java@11.0.2
-- $ mise install java@21.0.2
return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        local function setup_jdtls()
            local jdtls_dir = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/jdtls/")
            local jvmArg = "-javaagent:" .. jdtls_dir .. "lombok.jar"
            local java_21_path = vim.fn.expand("$HOME/.local/share/mise/installs/java/21.0.2/bin/java")

            local config = {
                cmd = { jdtls_dir .. "bin/jdtls", "--java-executable=" .. java_21_path, "--jvm-arg=" .. jvmArg },
                root_dir = vim.fs.dirname(vim.fs.find({".gradlew", ".git", "mvnw"}, { upward = true })[1]),
                settings = {
                    java = {
                        completion = {
                            favoriteStaticMembers = {
                                "org.junit.Assert.*",
                                "org.mockito.Mockito.*",
                                "org.mockito.ArgumentMatchers.*",
                            },
                        },
                        referencesCodeLens = {
                            enabled = true,
                        },
                    },
                    configuration = {
                        runtimes = {
                            {
                                name = "JavaSE-11",
                                path = vim.fn.expand("$HOME/.local/share/mise/installs/java/11.0.2/bin/java"),
                            },
                            {
                                name = "JavaSE-21",
                                path = vim.fn.expand("$HOME/.local/share/mise/installs/java/21.0.2/bin/java"),
                            },
                        },
                    },
                },
            }

            require("jdtls").start_or_attach(config)
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = setup_jdtls,
        })
    end,
}
