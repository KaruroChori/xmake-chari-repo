package("mcpp")
    set_homepage("https://git.chatomari.work/lazy-eggplant/mcpp")
    set_description("A C++26 reflection-based Model Context Protocol (MCP) server library")
    set_license("LGPL-3.0")
    set_kind("library", {headeronly = true})

    -- The reflection flags are mandatory; do not let xmake probe-and-drop them.
    set_policy("check.auto_ignore_flags", false)

    add_urls("https://git.chatomari.work/lazy-eggplant/mcpp.git",
             "https://github.com/KaruroChori/mcpp.git")

    add_versions("v0.2.0", "f9345f55c0626964732f1070998198cceaabefbe")
    add_versions("v0.2.1", "55f04836b721b2314624fdc1d80268d170236fb4")
    add_versions("v0.2.3", "85e8ded6178c46435725321de28bb40a7efa10a3")
    add_versions("v0.2.4", "0f466370e851fe85dc3de353605e81eeb0ec612c")

    -- mcpp-server builds with exceptions enabled, for exceptions-enabled
    -- consumers. The header-only core does not care.
    add_configs("exceptions", {description = "Build with exceptions enabled", default = false, type = "boolean"})
    -- The extended server (simdjson + threads + SocketHost). Consumers that only
    -- use the reflection/protocol core (with their own JSON parser) can turn it
    -- off and avoid the simdjson/fmt dependencies and the static library.
    add_configs("server", {description = "Build and install mcpp-server", default = true, type = "boolean"})

    on_load(function (package)
        package:add("cxflags", "-freflection", {force = true})
        if not package:config("server") then
            return
        end
        package:add("links", "mcpp-server")
        local exceptions = package:config("exceptions")
        -- mcpp-server links simdjson and fmt; consumers need them transitively.
        package:add("deps", "simdjson", {configs = {noexceptions = not exceptions}})
        package:add("deps", "fmt", {configs = {header_only = true}})
        if not exceptions then
            package:add("defines", "SIMDJSON_EXCEPTIONS=0")
        end
    end)

    on_install(function (package)
        if not package:config("server") then
            os.cp("include/mcpp", package:installdir("include"))
            os.cp("LICENSE", package:installdir("share/licenses/mcpp"))
            return
        end
        import("package.tools.xmake").install(package, {exceptions = package:config("exceptions")})
    end)

    on_test(function (package)
        if package:config("server") then
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
        else
            assert(package:check_cxxsnippets({test = [==[
                #include <mcpp/meta.hpp>
                #include <mcpp/protocol.hpp>
                void test() {
                    mcp::Registry registry{};
                    (void)registry;
                }
            ]==]}, {configs = {languages = "c++26"}}))
        end
    end)
package_end()
