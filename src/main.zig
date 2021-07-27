const std = @import("std");
const print = std.debug.print;
const c = @cImport({
    @cInclude("SDL.h");
    @cInclude("SDL_opengl.h");
    @cInclude("GL/gl.h");
});

const SDLError = error{
    Fatal,
};

fn sdl2err(code: c_int) !void {
    if (code == 0) {
        return;
    }
    std.log.err("SDL Error: {s}", .{c.SDL_GetError()});
    return SDLError.Fatal;
}

pub fn main() anyerror!void {
    try sdl2err(c.SDL_Init(c.SDL_INIT_EVERYTHING));
    defer c.SDL_Quit();

    const window_width = 800;
    const window_height = window_width;
    const window = b: {
        const window_maybe = c.SDL_CreateWindow("Test", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, window_width, window_height, c.SDL_WINDOW_SHOWN | c.SDL_WINDOW_OPENGL);
        if (window_maybe == null) {
            try sdl2err(1);
        }
        break :b window_maybe.?;
    };
    defer c.SDL_DestroyWindow(window);

    const gl_context = c.SDL_GL_CreateContext(window);
    defer c.SDL_GL_DeleteContext(gl_context);

    var event: c.SDL_Event = undefined;

    outer: while (true) {
        while (c.SDL_PollEvent(&event) != 0) {
            switch(event.type) {
                c.SDL_QUIT => {
                    break :outer;
                },
                else => {},
            }
        }

        c.glViewport(0, 0, window_width, window_height);
        c.glClearColor(0.0, 0.0, 0.0, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.SDL_GL_SwapWindow(window);
    }
}
