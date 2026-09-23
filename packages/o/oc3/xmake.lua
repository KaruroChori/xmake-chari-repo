package("oc3")
    set_kind("library", {headeronly = true})
    set_homepage("https://git.internal.chatomari.work/lazy-eggplant/oc3")
    set_description("KD-Tree acceleration library")
    set_license("AGPL3")

    add_urls("https://git.internal.chatomari.work/lazy-eggplant/oc3.git")

    on_install(function (package)
        import("package.tools.xmake").install(package, {}, {target = "oc3_headers"})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <oc3/oc3.hpp>
            void test() { /* use library API */ }
        ]]}, {configs = {languages = "c++23"}}))
    end)
