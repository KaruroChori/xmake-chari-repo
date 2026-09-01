package("kd3")
    set_homepage("https://github.com/karurochori/kd3")
    set_description("KD-Tree acceleration library")
    set_license("AGPL3")

    add_urls("https://github.com/karurochori/kd3.git")

    add_versions("v1.3.0", "d482ca2fdbb3d6cf9c5908aff670384f4f3f466c")
    add_versions("v1.1.0", "5bd769d76ab33a9cec46bcb5e90ece26f00f72dd")
    add_versions("v1.0.1", "86de5925e1cbfb36e93a3b5c080e5507e8a59ecb")

    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <kd3/kd3.hpp>
            void test() { /* use library API */ }
        ]]}, {configs = {languages = "c++23"}}))
    end)
