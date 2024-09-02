import std::io;
import raylib;

int width = 800;
int height = 600;

macro void @update_screen_size(&width, &height) {
    *width  = raylib::get_screen_width();
    *height = raylib::get_screen_height();
}

enum Shift : uint (String name) {
    NOON = "Manhã",
    AFTERNOON = "Tarde"
}

struct Person {
    String name;
    float[<2>] pos;
    float[<2>] size;
    bool active;

    uint font_size;
    char[<4>] rec_color; // Will be removed later when we add textures.
    char[<4>] text_color;
}

fn void init_person(Person* person, String name, float[<2>] pos, float[<2>] size, bool active, int font_size, char[<4>] rec_color, char[<4>] text_color) {
    *person = {
        .name = name,
        .pos  = pos,
        .size = size,
        .active = active,
        .font_size = font_size,
        .rec_color = rec_color,
        .text_color = text_color,
    };
}

fn void check_shift_collision(Person[] shift, float[<2>] mouse_pos) {
    foreach (&p : shift) {
        if (raylib::check_collision_point_rec(mouse_pos, {p.pos.x, p.pos.y, p.size.x, p.size.y})) {
            p.rec_color = raylib::MAGENTA;
        } else {
            p.rec_color = raylib::BLUE;
        }
    }
}

fn void display_person(Person* person) {
    raylib::draw_rectangle_lines((int)person.pos.x, (int)person.pos.y, (int)person.size.x, (int)person.size.y, person.rec_color);
    raylib::draw_text(person.name, (int)person.pos.x, (int)person.pos.y, person.font_size, person.text_color);
}

fn void main() {
    raylib::set_config_flags(ConfigFlags.FLAG_WINDOW_RESIZABLE.value | ConfigFlags.FLAG_WINDOW_ALWAYS_RUN.value);
    raylib::init_window(width, height, "Hello from c3");
    defer raylib::close_window();

    float[<2>] start_pos = { (float)(0.1*width), (float)(0.1*height) }; // Variable added to control where the group will be.
    float[<2>] rec_size = { 200.0, 100.0 };
    float padding = 100.0;

    String[*] noongp_names = { Shift.NOON.name, "henrique", "hugo" };
    String[*] afternoongp_names = { Shift.AFTERNOON.name, "gustavo", "matheus", "letícia" };

    const uint NGP_LENGTH = noongp_names.len;
    const uint AGP_LENGTH = afternoongp_names.len;

    // Noon shift creation.
    Person[NGP_LENGTH] noongp;
    for (uint i = 0; i < NGP_LENGTH; i++) {
        init_person(&noongp[i],
            noongp_names[i],
            { start_pos.x, start_pos.y+rec_size.y*i },
            rec_size,
            false,
            42,
            raylib::BLUE,
            raylib::WHITE);
    }

    // AfterNoon shift creation.
    Person[AGP_LENGTH] afternoongp;
    for (uint i = 0; i < AGP_LENGTH; i++) {
        afternoongp[i] = {
            .name       = afternoongp_names[i],
            .pos        = { start_pos.x+rec_size.x+padding, start_pos.y+rec_size.y*i },
            .size       = rec_size,
            .active     = false,
            .font_size  = 42,
            .rec_color  = raylib::BLUE,
            .text_color = raylib::WHITE,
        };
    }

    while (!raylib::window_should_close()) {
        @update_screen_size(width, height);
        float[<2>] mouse_pos = raylib::get_mouse_position();

        // Check for collisions with the users
        check_shift_collision(&noongp, mouse_pos);
        check_shift_collision(&afternoongp, mouse_pos);

        raylib::begin_drawing();
        raylib::clear_backgroud(raylib::BLACK);

        // Draw NOON shift.
        foreach (noon : noongp) {
            display_person(&noon);
        }

        // Draw AFTERNOON shift.
        foreach (aft : afternoongp) {
            display_person(&aft);
        }

        raylib::draw_fps(0, 0);
        raylib::end_drawing();
    }
}
