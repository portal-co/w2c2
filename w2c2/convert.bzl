def _wasi_transition_impl(settings, attr):
    return {
        "@platforms//os": "@platforms//os:wasi",
        "@platforms//cpu": "@platforms//cpu:wasm32",
    }

wasi_transition = transition(
    implementation = _wasi_transition_impl,
    inputs = [],
    outputs = ["@platforms//os", "@platforms//cpu"],
)

def _w2c2_apply_impl(ctx):
    cfile = ctx.actions.declare_file(ctx.attr.file_name + ".c")
    hfile = ctx.actions.declare_file(ctx.attr.file_name + ".h")
    wasm_file = ctx.actions.declare_file(ctx.attr.module_name + ".wasm")
    ctx.actions.symlink(
        target_file = ctx.executable.wasm,
        output = wasm_file,
        is_executable = False
    )
    ctx.actions.run(
        executable = ctx.executable._tool,
        inputs = [wasm_file],
        outputs = [cfile, hfile],
        arguments = ["-m",wasm_file.path,cfile.path]
    )
    return DefaultInfo(files = depset([cfile, hfile]))

w2c2_apply = rule(
    implementation = _w2c2_apply_impl,
    attrs = {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "wasm": attr.label(
            executable = True,
            cfg = wasi_transition,
        ),
        "_tool": attr.label(
            executable = true,
            default = "//w2c2",
            cfg = "exec",
        ),
        "file_name": attr.string(),
        "module_name": attr.string()
    },
)
