package("vourey")
    set_kind("library", {headeronly = true})
    set_homepage("https://git.internal.chatomari.work/lazy-eggplant/vourey")
    set_description("Visibility structures over low-dimensionality view-spaces")
    set_license("AGPL-3.0-only")

    add_urls("https://git.internal.chatomari.work/lazy-eggplant/vourey.git")

    add_versions("v1.0.0", "0e8a7591fd3155041e0b2bd50309ce5e14da1fbc")

    on_load(function (package)
        package:add("deps", "kd3")
    end)

    on_install(function (package)
        import("package.tools.xmake").install(package, {}, {target = "vourey"})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <vourey/vourey.hpp>
            void test() { /* use library API */ }
        ]]}, {configs = {languages = "c++23"}}))
    end)
