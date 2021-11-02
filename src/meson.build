i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

executable(
    meson.project_name(),
    'Application.vala',
    dependencies: [
        dependency('libadwaita-1'),
        dependency('libsoup-3.0'),
        dependency('json-glib-1.0')
    ],
    install: true
)

i18n.merge_file(
    input: '..' / 'data' / 'five_psalms_linux.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: meson.source_root() / 'po',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications'
)

i18n.merge_file(
    input: '..' / 'data' / 'five_psalms_linux.appdata.xml.in',
    output: meson.project_name() + '.appdata.xml',
    po_dir: meson.source_root() / 'po',
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
)