package("omp-stub")
    set_homepage("https://github.com/lazy-eggplant/omp-stub")
    set_description("Simple stub for OpenMP, to avoid refactoring code")
    set_license("OpenMP Architecture Review Board")

    add_urls("https://github.com/lazy-eggplant/omp-stub.git")

    --add_versions("v0.9", "ef957307da15b1258a70961942840bcf54225a8d75315dcbc156186eba35b1a7")

    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <omp.h>
            void test() { /* use library API */ }
        ]]}, {configs = {languages = "c11"}}))
    end)
