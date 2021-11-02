
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
        var psalm1_page = (Adw.StatusPage) builder.get_object ("psalm1_page");
        psalm1_page.title = "Psalm 1";
        var psalm2_page = (Adw.StatusPage) builder.get_object ("psalm2_page");
        psalm2_page.title = "Psalm 2";
        var psalm3_page = (Adw.StatusPage) builder.get_object ("psalm3_page");
        psalm3_page.title = "Psalm 3";
        var psalm4_page = (Adw.StatusPage) builder.get_object ("psalm4_page");
        psalm4_page.title = "Psalm 4";
        var psalm5_page = (Adw.StatusPage) builder.get_object ("psalm5_page");
        psalm5_page.title = "Psalm 5";
    }

    void set_content (Gtk.Builder builder) {
        var psalm1 = (Gtk.Label) builder.get_object ("psalm1");
        var psalm2 = (Gtk.Label) builder.get_object ("psalm2");
        var psalm3 = (Gtk.Label) builder.get_object ("psalm3");
        var psalm4 = (Gtk.Label) builder.get_object ("psalm4");
        var psalm5 = (Gtk.Label) builder.get_object ("psalm5");

        var text1 = new Thread<void> ("get_psalm", () => {
            psalm1.set_text (get_psalm (1));
        });

        var text2 = new Thread<void> ("get_psalm", () => {
            psalm2.set_text (get_psalm (2));
        });

        var text3 = new Thread<void> ("get_psalm", () => {
            psalm3.set_text (get_psalm (3));
        });

        var text4 = new Thread<void> ("get_psalm", () => {
            psalm4.set_text (get_psalm (4));
        });

        var text5 = new Thread<void> ("get_psalm", () => {
            psalm5.set_text (get_psalm (5));
        });

        text1.join ();
        text2.join ();
        text3.join ();
        text4.join ();
        text5.join ();
    }

    string get_psalm (int psalm) {
        var url = @"https://getbible.net/v2/web/19/$psalm.json";
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", url);
        var data = session.send_and_read (message);
        var parser = new Json.Parser ();
        parser.load_from_data ((string) data.get_data ());
        var root_object = parser.get_root ().get_object ();
        string passage = "";
        var verses = root_object.get_array_member ("verses");
        Json.Object element;
        for (int i = 0; i < verses.get_length (); i++) {
            element = verses.get_object_element (i);
            passage = string.join ("", passage, element.get_string_member ("text"), null);
        }

        return passage;
    }

    public static int main (string[] args) {
        return new FivePsalmsApp ().run (args);
    }
}