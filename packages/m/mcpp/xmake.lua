package("mcpp")
    set_kind("library", {headeronly = true})
    set_homepage("https://git.chatomari.work/lazy-eggplant/mcpp")
    set_description("C++26 reflection/protocol core for the Model Context Protocol")
    set_license("LGPL-3.0")

    -- The reflection flags are mandatory; do not let xmake probe-and-drop them.
    set_policy("check.auto_ignore_flags", false)

    add_urls("https://git.chatomari.work/lazy-eggplant/mcpp.git",
             "https://github.com/KaruroChori/mcpp.git")
    add_versions("v0.2.0", "f9345f55c0626964732f1070998198cceaabefbe")
    add_versions("v0.2.1", "55f04836b721b2314624fdc1d80268d170236fb4")
    add_versions("v0.2.3", "85e8ded6178c46435725321de28bb40a7efa10a3")
    add_versions("v0.2.4", "0f466370e851fe85dc3de353605e81eeb0ec612c")

    on_load(function (package)
        package:add("cxflags", "-freflection", {force = true})
    end)

    on_install(function (package)
        local includedir = path.join(package:installdir(), "include")
        os.mkdir(includedir)
        os.cp("include/mcpp", includedir)
        local licensedir = path.join(package:installdir(), "share", "licenses", "mcpp")
        os.mkdir(licensedir)
        os.cp("LICENSE", licensedir)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [==[
            #include <mcpp/meta.hpp>
            #include <mcpp/protocol.hpp>
            void test() {
                mcp::Registry registry{};
                (void)registry;
            }
        ]==]}, {configs = {languages = "c++26"}}))
    end)
package_end()
