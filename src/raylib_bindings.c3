module raylib;

// Functions
extern fn void init_window(CInt width, CInt height, char* title) @extern("InitWindow");
extern fn void close_window() @extern("CloseWindow");
extern fn bool window_should_close() @extern ("WindowShouldClose");
extern fn void begin_drawing() @extern("BeginDrawing");
extern fn void clear_backgroud(char[4] color) @extern("ClearBackground");
extern fn void end_drawing() @extern("EndDrawing");
extern fn void draw_rectangleV(float[2] position, float[2] size, char[4] color) @extern("DrawRectangleV");
extern fn void draw_rectangle_lines(CInt posX, CInt posY, CInt width, CInt height, char[4] color) @extern("DrawRectangleLines");
extern fn CInt get_screen_width() @extern("GetScreenWidth");
extern fn CInt get_screen_height() @extern("GetScreenHeight");
extern fn void set_config_flags(CUInt flags) @extern("SetConfigFlags");
extern fn void draw_text(char* text, CInt posX, CInt posY, CInt fontSize, char[4] color) @extern("DrawText");
extern fn CInt measure_text(char *text, CInt fontSize) @extern("MeasureText");
extern fn char* text_format(char *text, ...) @extern("TextFormat");
extern fn void draw_fps(CInt posX, CInt posY) @extern("DrawFPS");
extern fn bool check_collision_point_rec(float[2] point, float[4] rec) @extern("CheckCollisionPointRec");
extern fn float[<2>] get_mouse_position() @extern("GetMousePosition");
extern fn void draw_circle_v(float[2] center, float radius, char[4] color) @extern("DrawCircleV");

// Definitions

const char[<4>] BLACK   = { 0, 0, 0, 255 };
const char[<4>] WHITE   = { 255, 255, 255, 255 };
const char[<4>] RED     = { 255, 0, 0, 255 };
const char[<4>] GREEN   = { 0, 255, 0, 255 };
const char[<4>] BLUE    = { 0, 0, 255, 255 };
const char[<4>] MAGENTA = { 255, 0, 255, 255 };

enum ConfigFlags : uint (uint value) {
    FLAG_VSYNC_HINT               = 0x00000040,
    FLAG_FULLSCREEN_MODE          = 0x00000002,
    FLAG_WINDOW_RESIZABLE         = 0x00000004,
    FLAG_WINDOW_UNDECORATED       = 0x00000008,
    FLAG_WINDOW_HIDDEN            = 0x00000080,
    FLAG_WINDOW_MINIMIZED         = 0x00000200,
    FLAG_WINDOW_MAXIMIZED         = 0x00000400,
    FLAG_WINDOW_UNFOCUSED         = 0x00000800,
    FLAG_WINDOW_TOPMOST           = 0x00001000,
    FLAG_WINDOW_ALWAYS_RUN        = 0x00000100,
    FLAG_WINDOW_TRANSPARENT       = 0x00000010,
    FLAG_WINDOW_HIGHDPI           = 0x00002000,
    FLAG_WINDOW_MOUSE_PASSTHROUGH = 0x00004000,
    FLAG_MSAA_4X_HINT             = 0x00000020,
    FLAG_INTERLACED_HINT          = 0x00010000 
}

// Types
struct Rectangle {
    float[<2>] pos;
    float[<2>] size;
}
