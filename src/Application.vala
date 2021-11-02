
public class FivePsalmsApp : Adw.Application {
    public FivePsalmsApp () {
        Object (
            application_id: "com.github.sirthomas.five_psalms_linux",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var builder = new Gtk.Builder.from_file ("../data/builder.ui");

        var window = (Gtk.Window) builder.get_object ("window");
        window.set_application (this);

        set_titles (builder);
        set_content (builder);

        window.present ();
    }

    void set_titles (Gtk.Builder builder) {
        var psalm1_title = (Gtk.Label) builder.get_object ("psalm1_title");
        psalm1_title.set_markup ("<span size=\"xx-large\">Psalm 1</span>");
        var psalm2_title = (Gtk.Label) builder.get_object ("psalm2_title");
        psalm2_title.set_markup ("<span size=\"xx-large\">Psalm 2</span>");
        var psalm3_title = (Gtk.Label) builder.get_object ("psalm3_title");
        psalm3_title.set_markup ("<span size=\"xx-large\">Psalm 3</span>");
        var psalm4_title = (Gtk.Label) builder.get_object ("psalm4_title");
        psalm4_title.set_markup ("<span size=\"xx-large\">Psalm 4</span>");
        var psalm5_title = (Gtk.Label) builder.get_object ("psalm5_title");
        psalm5_title.set_markup ("<span size=\"xx-large\">Psalm 5</span>");
    }

    void set_content (Gtk.Builder builder) {
        var psalm1 = (Gtk.Label) builder.get_object ("psalm1");
        psalm1.set_label (get_psalm (1));
        var psalm2 = (Gtk.Label) builder.get_object ("psalm2");
        psalm2.set_label ("Psalm 2");
        var psalm3 = (Gtk.Label) builder.get_object ("psalm3");
        psalm3.set_label ("Psalm 3");
        var psalm4 = (Gtk.Label) builder.get_object ("psalm4");
        psalm4.set_label ("Psalm 4");
        var psalm5 = (Gtk.Label) builder.get_object ("psalm5");
        psalm5.set_label ("Psalm 5");
    }

    string get_psalm (int psalm) {
        var url = "https://getbible.net/v2/web/1/2.json";
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", url);
        var data = session.send_and_read (message);
        return (string) data.get_data ();
    }

    public static int main (string[] args) {
        return new FivePsalmsApp ().run (args);
    }
}