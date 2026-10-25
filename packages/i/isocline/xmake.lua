package("isocline")
    set_homepage("https://github.com/daanx/isocline")
    set_description("Isocline is a portable GNU readline alternative")
    set_license("MIT")

    add_urls("https://github.com/daanx/isocline.git")
    add_versions("1.1.0", "8d6dc1ef95b1b46711e66eb23d39d4467a0fcdac")

    add_deps("cmake")

    on_install(function (package)
        io.replace("src/completers.c", "__finddata64_t", "_finddatai64_t", {plain = true})

        local configs = {}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        if package:is_plat("windows") and package:config("shared") then
            table.insert(configs, "-DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON")
        end

        import("package.tools.cmake").build(package, configs, {buildir = "build"})
        os.cp("include", package:installdir())
        if package:config("shared") then
            os.trycp("build/**.dylib", package:installdir("lib"))
            os.trycp("build/**.so", package:installdir("lib"))
            os.trycp("build/**.dll", package:installdir("bin"))
            os.trycp("build/**.lib", package:installdir("lib"))
        else
            os.trycp("build/**.a", package:installdir("lib"))
            os.trycp("build/isocline.lib", package:installdir("lib"))
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test() {
                ic_set_history("history.txt", 100);
            }
        ]]}, {configs = {languages = "c++11"}, includes = "isocline.h"}))
    end)
