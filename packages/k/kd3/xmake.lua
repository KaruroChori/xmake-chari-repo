package("kd3")
    set_homepage("https://github.com/karurochori/kd3")
    set_description("KD-Tree acceleration library")
    set_license("AGPL3")

    add_urls("https://github.com/karurochori/kd3.git")

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
