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
uint[GROUPS_NUM] cleaners;

const uint NGP_LENGTH  = noongp_names.len;
const uint AGP_LENGTH  = afternoongp_names.len;
const uint GROUPS_NUM  = Shift.elements;
const uint PERSONS_NUM = NGP_LENGTH+AGP_LENGTH;


fn void init_person(Person* person, String name, float[<2>] pos, float[<2>] size, bool active, int font_size, char[<4>] rec_color, char[<4>] text_color) {
    *person = {
        .name = name,
        .pos  = pos,
        .size = size,
        .font_size = font_size,
        .rec_color = rec_color,
        .text_color = text_color,
    };
}

fn void check_persons_collision(Person[] persons, float[<2>] mouse_pos, uint* cleaners) {
    foreach (index, &p : persons) {
        if (raylib::check_collision_point_rec(mouse_pos, {p.pos.x, p.pos.y, p.size.x, p.size.y})) {
            p.rec_color = raylib::MAGENTA;
            if (raylib::is_mouse_button_pressed(raylib::MouseButton.MOUSE_BUTTON_LEFT.value)) {
                if (index < NGP_LENGTH) {
                    cleaners[0] = (uint)index; // NOON group(0)
                }
                else if (index >= NGP_LENGTH) {
                    cleaners[1] = (uint)index; // AFTERNOON group(1)
                }
                //*current_cleaner = (uint)index;
            }
        } else {
            p.rec_color = raylib::BLUE;
        }
    }
}

fn void display_person(Person* person) {
    raylib::draw_rectangle_lines((int)person.pos.x, (int)person.pos.y, (int)person.size.x, (int)person.size.y, person.rec_color);
    raylib::draw_text(person.name, (int)person.pos.x, (int)person.pos.y, person.font_size, person.text_color);
}

fn void display_cleaner(Person* person, float[<2>] pos) {
    raylib::draw_rectangle_lines((int)pos.x, (int)pos.y, (int)person.size.x, (int)person.size.y, person.rec_color);
    raylib::draw_text(person.name, (int)pos.x, (int)pos.y, person.font_size, person.text_color);
}


fn void main() {
    raylib::set_config_flags(ConfigFlags.FLAG_WINDOW_RESIZABLE.value | ConfigFlags.FLAG_WINDOW_ALWAYS_RUN.value);
    raylib::init_window(width, height, "PcClean");
    defer raylib::close_window();

    float[<2>] start_pos = { (float)(0.1*width), (float)(0.1*height) }; // Variable added to control where the group pos is.
    float[<2>] rec_size = { 200.0, 50.0 };
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
            uint idx = i-NGP_LENGTH; // Resets the counter for the next group
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


    //uint cleaner_index;
    // Cleaners start position
    //float[<2>] pos = { (float)width*0.1, (float)height*0.9-person.size.y };
    float[<2>] pos = { (float)width*0.1, (float)height*0.7 };
    
    while (!raylib::window_should_close()) {
        @update_screen_size(width, height);
        float[<2>] mouse_pos = raylib::get_mouse_position();

        // Check for collisions with persons
        check_persons_collision(&persons, mouse_pos, &cleaners);
        //raylib::draw_text(raylib::text_format("index: %zu", index), 0, height-40, 32, raylib::GREEN);

        //cleaner_index = get_cleaner(&persons); OLD
        raylib::begin_drawing();
        raylib::clear_backgroud(raylib::BLACK);

        // Draw every person
        foreach (idx, p : persons) {
            display_person(&p);
            //char* t = raylib::text_format("index: %d", cleaner_index);
            //raylib::draw_text(t, raylib::measure_text(t, 30)*((CInt)cleaner_index), height-30, 24, raylib::GREEN);
        }

        // Draw the cleaners 
        for (uint i = 0; i < cleaners.len; i++) {
            uint index = cleaners[i];
            display_cleaner(&persons[index], { 
                pos.x+(persons[index].size.x+100)*i, pos.y
            });
        }

        raylib::draw_fps(0, 0);
        raylib::end_drawing();
    }
}
