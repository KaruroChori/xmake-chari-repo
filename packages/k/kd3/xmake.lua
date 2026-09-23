package("kd3")
    set_kind("library", {headeronly = true})
    set_homepage("https://git.chatomari.work/lazy-eggplant/kd3")
    set_description("KD-Tree acceleration library")
    set_license("AGPL3")

    add_urls("https://git.chatomari.work/lazy-eggplant/kd3.git",
             "https://github.com/karurochori/kd3.git")

    add_versions("v1.3.1", "d6baf2c6cb15697bca35d2488c5291bba82611c8")
    add_versions("v1.3.0", "d482ca2fdbb3d6cf9c5908aff670384f4f3f466c")
    add_versions("v1.1.0", "5bd769d76ab33a9cec46bcb5e90ece26f00f72dd")
    add_versions("v1.0.1", "86de5925e1cbfb36e93a3b5c080e5507e8a59ecb")

    add_configs("openmp", {description = "Link real OpenMP instead of the serial omp-stub", default = true, type = "boolean"})

    on_load(function (package)
        package:add("deps", package:config("openmp") and "openmp" or "omp-stub")
    end)

    on_install(function (package)
        import("package.tools.xmake").install(package, {use_openmp = package:config("openmp")})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <kd3/kd3.hpp>
            void test() { /* use library API */ }
        ]]}, {configs = {languages = "c++23"}}))
    end)
