
public class FivePsalmsApp : Gtk.Application {
    public FivePsalmsApp () {
        Object (
            application_id: "com.github.sirthomas.five_psalms_linux",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var main_window = new Adw.ApplicationWindow (this) {
            title = _("Five Psalms"),
            default_height = 812,
            default_width = 375
        };

        main_window.present ();
    }

    public static int main (string[] args) {
        return new FivePsalmsApp ().run (args);
    }
}