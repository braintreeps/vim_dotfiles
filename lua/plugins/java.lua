return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        local function setup_jdtls()
            local jdtls_dir = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/jdtls/")
            local jvmArg = "-javaagent:" .. jdtls_dir .. "lombok.jar"
            local java_21_path = vim.fn.system("mise where java@21"):gsub("%s+", "") .. "/bin/java"

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
                                path = vim.fn.system("mise where java@11"):gsub("%s+", "") .. "/bin/java",
                            },
                            {
                                name = "JavaSE-17",
                                path = vim.fn.system("mise where java@17"):gsub("%s+", "") .. "/bin/java",
                            },
                            {
                                name = "JavaSE-21",
                                path = java_21_path,
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
