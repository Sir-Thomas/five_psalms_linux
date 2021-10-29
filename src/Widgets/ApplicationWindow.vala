
public class FivePsalms.ApplicationWindow : Adw.ApplicationWindow {

    public ApplicationWindow (Gtk.Application app) {
        Object (
            application: app
        );
    }

    construct {
        var switcher = new Adw.ViewSwitcher ();
        var view_stack = new Adw.ViewStack ();

        view_stack.add (new Gtk.Label ("Cool"));
        view_stack.add (new Gtk.Label ("Beans"));

        switcher.stack = view_stack;
        content = new Gtk.Label ("hi");

        content.show ();
        show ();
    }
}