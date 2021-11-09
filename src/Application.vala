
public class FivePsalmsApp : Adw.Application {
    int[] num = { 1, 2, 3, 4, 5 };

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

        set_days ();
        set_content (builder);

        window.present ();
    }

    void set_days () {
        var now = new GLib.DateTime.now_local ();
        var day = int.parse (now.format ("%e"));
        num = { day, day + 30, day + 60, day + 90, day + 120 };
    }

    void set_content (Gtk.Builder builder) {
        var psalm1_page = (Adw.ViewStackPage) builder.get_object ("psalm1-page");
        var psalm2_page = (Adw.ViewStackPage) builder.get_object ("psalm2-page");
        var psalm3_page = (Adw.ViewStackPage) builder.get_object ("psalm3-page");
        var psalm4_page = (Adw.ViewStackPage) builder.get_object ("psalm4-page");
        var psalm5_page = (Adw.ViewStackPage) builder.get_object ("psalm5-page");

        psalm1_page.title = @"Psalm $(num[0])";
        psalm2_page.title = @"Psalm $(num[1])";
        psalm3_page.title = @"Psalm $(num[2])";
        psalm4_page.title = @"Psalm $(num[3])";
        psalm5_page.title = @"Psalm $(num[4])";

        var psalm1 = (Gtk.TextView) builder.get_object ("psalm1");
        var psalm2 = (Gtk.TextView) builder.get_object ("psalm2");
        var psalm3 = (Gtk.TextView) builder.get_object ("psalm3");
        var psalm4 = (Gtk.TextView) builder.get_object ("psalm4");
        var psalm5 = (Gtk.TextView) builder.get_object ("psalm5");

        string p1 = @"<span size=\"xx-large\">Psalm $(num[0])</span>\n";
        string p2 = @"<span size=\"xx-large\">Psalm $(num[1])</span>\n";
        string p3 = @"<span size=\"xx-large\">Psalm $(num[2])</span>\n";
        string p4 = @"<span size=\"xx-large\">Psalm $(num[3])</span>\n";
        string p5 = @"<span size=\"xx-large\">Psalm $(num[4])</span>\n";

        var text1 = new Thread<void> ("get_psalm", () => {
            var b = new Gtk.TextBuffer(new Gtk.TextTagTable ());
            Gtk.TextIter iter;
            b.get_end_iter (out iter);
            b.insert_markup (ref iter, p1, p1.length);
            string p = get_psalm (num[0]);
            b.insert_markup (ref iter, p, p.length);
            psalm1.buffer = b;
        });

        var text2 = new Thread<void> ("get_psalm", () => {
            var b = new Gtk.TextBuffer(new Gtk.TextTagTable ());
            Gtk.TextIter iter;
            b.get_end_iter (out iter);
            b.insert_markup (ref iter, p2, p2.length);
            string p = get_psalm (num[1]);
            b.insert_markup (ref iter, p, p.length);
            psalm2.buffer = b;
        });

        var text3 = new Thread<void> ("get_psalm", () => {
            var b = new Gtk.TextBuffer(new Gtk.TextTagTable ());
            Gtk.TextIter iter;
            b.get_end_iter (out iter);
            b.insert_markup (ref iter, p3, p3.length);
            string p = get_psalm (num[2]);
            b.insert_markup (ref iter, p, p.length);
            psalm3.buffer = b;
        });

        var text4 = new Thread<void> ("get_psalm", () => {
            var b = new Gtk.TextBuffer(new Gtk.TextTagTable ());
            Gtk.TextIter iter;
            b.get_end_iter (out iter);
            b.insert_markup (ref iter, p4, p4.length);
            string p = get_psalm (num[3]);
            b.insert_markup (ref iter, p, p.length);
            psalm4.buffer = b;
        });

        var text5 = new Thread<void> ("get_psalm", () => {
            var b = new Gtk.TextBuffer(new Gtk.TextTagTable ());
            Gtk.TextIter iter;
            b.get_end_iter (out iter);
            b.insert_markup (ref iter, p5, p5.length);
            string p = get_psalm (num[4]);
            b.insert_markup (ref iter, p, p.length);
            psalm5.buffer = b;
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
        string passage = "<big>";
        var verses = root_object.get_array_member ("verses");
        Json.Object element;
        for (int i = 0; i < verses.get_length (); i++) {
            element = verses.get_object_element (i);
            passage = string.join ("", passage, @"<sup>$(i+1)</sup> ", element.get_string_member ("text")._strip (), " ", null);
        }

        passage = string.join ("", passage, "</big>", null);
        return passage;
    }

    public static int main (string[] args) {
        return new FivePsalmsApp ().run (args);
    }
}