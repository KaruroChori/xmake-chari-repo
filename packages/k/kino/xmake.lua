package("kino")
    set_kind("library", {headeronly = true})
    set_homepage("https://git.internal.chatomari.work/lazy-eggplant/kino")
    set_description("IVF + SQ8 approximate nearest neighbour search for high dimensional vectors")
    set_license("AGPL-3.0-only")

    add_urls("https://git.internal.chatomari.work/lazy-eggplant/kino.git")

    add_configs("simd", {description = "Use the hand-written SIMD query kernels", default = false, type = "boolean"})

    on_install(function (package)
        import("package.tools.xmake").install(package,
            {with_simd = package:config("simd")},
            {target = "kino_headers"})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <kino/kino.hpp>
            void test() { kino::limits<float, 4> l; (void)l; }
        ]]}, {configs = {languages = "c++23"}}))
    end)
