package("reflite")
    set_kind("library", {headeronly = true})
    set_homepage("https://codeberg.org/karurochori/reflite")
    set_description("C++26 reflection wrapper for SQLITE")
    set_license("AGPL3.0")

    add_urls("https://codeberg.org/karurochori/reflite.git")

    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)

    --on_test(function (package)
    --    assert(package:check_cxxsnippets({test = [[
    --        #include <reflite/reflite.hpp>
    --        void test() { /* use library API */ }
    --    ]]}, {configs = {languages = "c++26"}, flags="-frefleciton"}))
    --end)
