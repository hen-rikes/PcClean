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

String[*] noongp_names = { 
    Shift.NOON.name,
    "henrique",
    "hugo" 
};

String[*] afternoongp_names = { 
    Shift.AFTERNOON.name,
    "gustavo",
    "matheus",
    "letícia" 
};

Person[PERSONS_NUM] persons;

const uint NGP_LENGTH  = noongp_names.len;
const uint AGP_LENGTH  = afternoongp_names.len;
const uint GROUPS_NUM  = Shift.elements;
const uint PERSONS_NUM = NGP_LENGTH+AGP_LENGTH;


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

fn uint check_persons_collision(Person[] persons, float[<2>] mouse_pos) {
    uint idx = 0;
    foreach (index, &p : persons) {
        if (raylib::check_collision_point_rec(mouse_pos, {p.pos.x, p.pos.y, p.size.x, p.size.y})) {
            p.rec_color = raylib::MAGENTA;
            idx = (uint)index;
            if (raylib::is_mouse_button_pressed(raylib::MouseButton.MOUSE_BUTTON_LEFT.value)) {
                p.active = ~p.active;
                idx = (uint)index;
            }
        } else {
            p.rec_color = raylib::BLUE;
        }
    }
    return idx;
}

fn void display_person(Person* person) {
    raylib::draw_rectangle_lines((int)person.pos.x, (int)person.pos.y, (int)person.size.x, (int)person.size.y, person.rec_color);
    raylib::draw_text(person.name, (int)person.pos.x, (int)person.pos.y, person.font_size, person.text_color);

    //if (person.active) {
    //    person.rec_color = raylib::RED;
    //} else {
    //    person.rec_color = raylib::GREEN;
    //}
}


fn void main() {
    raylib::set_config_flags(ConfigFlags.FLAG_WINDOW_RESIZABLE.value | ConfigFlags.FLAG_WINDOW_ALWAYS_RUN.value);
    raylib::init_window(width, height, "PcClean");
    defer raylib::close_window();

    float[<2>] start_pos = { (float)(0.1*width), (float)(0.1*height) }; // Variable added to control where the group pos is.
    float[<2>] rec_size = { 200.0, 100.0 };
    float padding = 100.0;

    // Initialiazing every person
    for (uint i = 0; i < PERSONS_NUM; i++) {
        if (i < NGP_LENGTH) {
            init_person(&persons[i],
                .name       = noongp_names[i],
                .pos        = { start_pos.x, start_pos.y+rec_size.y*i },
                .size       = rec_size,
                .active     = false,
                .font_size  = 42,
                .rec_color  = raylib::BLUE,
                .text_color = raylib::WHITE);
        }
        else if (i >= NGP_LENGTH) {
            uint idx = i-NGP_LENGTH;
            init_person(&persons[i],
                .name       = afternoongp_names[idx],
                .pos        = { start_pos.x+rec_size.x+padding, start_pos.y+rec_size.y*(idx) },
                .size       = rec_size,
                .active     = false,
                .font_size  = 42,
                .rec_color  = raylib::BLUE,
                .text_color = raylib::WHITE,
            );
        }
    }
    
    while (!raylib::window_should_close()) {
        @update_screen_size(width, height);
        float[<2>] mouse_pos = raylib::get_mouse_position();

        // Check for collisions with persons
        uint index = check_persons_collision(&persons, mouse_pos);
        //raylib::draw_text(raylib::text_format("index: %zu", index), 0, height-40, 32, raylib::GREEN);

        raylib::begin_drawing();
        raylib::clear_backgroud(raylib::BLACK);

        // Draw every person
        foreach (idx, p : persons) {
            display_person(&p);
            if (p.active) {
                char* t = raylib::text_format("index: %d", idx);
                raylib::draw_text(t, raylib::measure_text(t, 30)*((CInt)idx), height-30, 24, raylib::GREEN);
            }
        }

        raylib::draw_fps(0, 0);
        raylib::end_drawing();
    }
}
