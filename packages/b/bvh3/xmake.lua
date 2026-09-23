package("bvh3")
    set_kind("library", {headeronly = true})
    set_homepage("https://git.internal.chatomari.work/lazy-eggplant/bvh3")
    set_description("BVH acceleration library")
    set_license("AGPL-3.0-only")

    add_urls("https://git.internal.chatomari.work/lazy-eggplant/bvh3.git")

    add_configs("openmp", {description = "Link real OpenMP instead of the serial omp-stub", default = false, type = "boolean"})

    on_load(function (package)
        package:add("deps", package:config("openmp") and "openmp" or "omp-stub")
    end)

    on_install(function (package)
        import("package.tools.xmake").install(package,
            {use_openmp = package:config("openmp")},
            {target = "bvh3_headers"})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <bvh3/bvh3.hpp>
            void test() { /* use library API */ }
        ]]}, {configs = {languages = "c++23"}}))
    end)
