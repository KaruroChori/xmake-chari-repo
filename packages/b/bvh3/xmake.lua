package("bvh3")
    set_homepage("https://git.internal.chatomari.work/lazy-eggplant/bvh3")
    set_description("BVH acceleration library")
    set_license("AGPL-3.0-only")

    add_urls("https://git.internal.chatomari.work/lazy-eggplant/bvh3.git")

    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <bvh3/bvh3.hpp>
            void test() { /* use library API */ }
        ]]}, {configs = {languages = "c++23"}}))
    end)
