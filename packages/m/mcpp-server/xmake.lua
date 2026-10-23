package("mcpp-server")
    set_homepage("https://git.chatomari.work/lazy-eggplant/mcpp")
    set_description("Extended mcpp server: simdjson + thread pool + SocketHost")
    set_license("LGPL-3.0")

    set_policy("check.auto_ignore_flags", false)

    add_urls("https://git.chatomari.work/lazy-eggplant/mcpp.git",
             "https://github.com/KaruroChori/mcpp.git")
    add_versions("v0.2.0", "f9345f55c0626964732f1070998198cceaabefbe")
    add_versions("v0.2.1", "55f04836b721b2314624fdc1d80268d170236fb4")
    add_versions("v0.2.3", "85e8ded6178c46435725321de28bb40a7efa10a3")
    add_versions("v0.2.4", "0f466370e851fe85dc3de353605e81eeb0ec612c")

    add_configs("exceptions", {description = "Build with exceptions enabled", default = false, type = "boolean"})

    on_load(function (package)
        local exceptions = package:config("exceptions")
        package:add("deps", "mcpp")
        package:add("deps", "simdjson", {configs = {noexceptions = not exceptions}})
        package:add("deps", "fmt", {configs = {header_only = true}})
        package:add("cxflags", "-freflection", {force = true})
        if not exceptions then
            package:add("defines", "SIMDJSON_EXCEPTIONS=0")
        end
    end)

    on_install(function (package)
        import("package.tools.xmake").install(package, {exceptions = package:config("exceptions")},
                                              {target = "mcpp-server"})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [==[
            #include <mcpp/mcpp.hpp>
            #include <mcpp-server/mcpp-server.hpp>
            struct [[= mcp::tool_group{} ]] ops {
                [[= mcp::tool{ .description = mcp::str("Adds two integers.") } ]]
                static auto add(std::int64_t a, std::int64_t b) {
                    return (struct{ std::int64_t sum; }){ a + b };
                }
            };
            void test() {
                auto tools = mcp::register_tools<^^ops, mcp::simdjson_parser>();
                (void)tools;
            }
        ]==]}, {configs = {languages = "c++26"}}))
    end)
package_end()
