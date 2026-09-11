package("vs.xml")
    set_homepage("https://github.com/lazy-eggplant/vs.xml")
    set_description("A mostly-compliant C++23 XML parser, tree builder and utilities, with a compact binary representation")
    set_license("LGPL-3.0-only")

    add_urls("https://github.com/lazy-eggplant/vs.xml.git")

    add_versions("v0.3.1", "cfdfa5e41551f35b7a73ad33a8a7e813ea481446")

    add_deps("fmt")

    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <vs-xml/document.hpp>
            void test() { /* use library API */ }
        ]]}, {configs = {languages = "c++23"}}))
    end)
