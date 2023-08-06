"""Google fonts installer utility."""
import argparse
import os
import subprocess
import sys
import textwrap


__version__ = '0.3.1'


class GoogleFontInstaller:
    """Google fonts installer utility."""

    repo_url = 'https://github.com/google/fonts.git'

    def __init__(self, work_dir, fonts_dir, config_path):
        """Remember the configuration paths."""
        self.work_dir = self._abs_path(work_dir)
        self.fonts_dir = self._abs_path(fonts_dir)
        self.config_path = self._abs_path(config_path)

    def _abs_path(self, path):
        path = os.path.expanduser(path)
        if not os.path.isabs(path):
            os.path.abspath(os.path.join(os.getcwd(), path))
        return path

    def __call__(self):
        """Get fonts and create links."""
        fonts = self.read_config(self.config_path)
        self.init_git(self.work_dir, self.repo_url)
        self.write_sparse_info(self.work_dir, fonts)
        self.update_git(self.work_dir)
        self.link_fonts(self.fonts_dir, self.work_dir, fonts)
        self.clean_broken_links(self.fonts_dir)

    def read_config(self, config_path):
        """Read list of fonts to install from config file."""
        print("Read fonts configuration")
        fonts = []
        with open(config_path, mode='r', encoding='utf-8') as conf:
            fonts = [line.rstrip('\n') for line in conf]
        print(
            "  Fonts to be installed:\n" +
            '\n'.join('    ' + font for font in fonts))
        return fonts

    def init_git(self, work_dir, repo_url):
        """Init git repository if required."""
        print("Initialize git repository")
        # Create work_dir.
        if not os.path.exists(work_dir):
            print("  Create working directory at " + work_dir)
            os.makedirs(work_dir)
        # Check for existing .git dir.
        if not os.path.exists(os.path.join(work_dir, '.git')):
            os.chdir(work_dir)
            # Init empty repository.
            print("  Init empty Git repository")
            subprocess.check_call(['git', 'init'])
            print("  Enable sparse checkout")
            subprocess.check_call(
                ['git', 'config', 'core.sparseCheckout', 'true'])
            print("  Add remote to github")
            subprocess.check_call(['git', 'remote', 'add', 'origin', repo_url])
        else:
            print("  Git repository exists")

    def write_sparse_info(self, work_dir, fonts):
        """Write ``.git/info/sparse-checkout`` configuration."""
        print("Write sparse checkout config")
        with open(
                os.path.join(work_dir, '.git', 'info', 'sparse-checkout'),
                mode='w', encoding='utf-8') as gisc:
            gisc.writelines([line + '\n' for line in fonts])

    def update_git(self, work_dir):
        """Pull changes and run ``read-tree`` to update sparse checkout."""
        print("Update git repository")
        os.chdir(work_dir)
        print("  Pull changes from github")
        subprocess.check_call(['git', 'pull', '--depth=1', 'origin', 'main'])
        print("  Update working tree")
        subprocess.check_call(['git', 'read-tree', '--reset', '-u', 'HEAD'])

    def link_fonts(self, fonts_dir, work_dir, fonts):
        """Create symlinks for all ``fonts`` in ``fonts_dir``."""
        print("Create symlinks for installed fonts")
        for font in fonts:
            # Make sure we have a trailing slash.
            font = font.rstrip('/') + '/'
            #source = os.path.join(work_dir, font)
            font_name = font.rsplit('/', 2)[-2]
            source = os.path.join("/usr/share/fonts/truetype", font_name)
            target = os.path.join(fonts_dir, font_name)
            # Skip existing symlinks.
            if not os.path.exists(target):
                print("  Symlink {} to {}".format(
                    reduceuser(target), reduceuser(source)))
                os.symlink(source, target)
            else:
                print("  Skip existing symlink {} to {}".format(
                    reduceuser(target), reduceuser(source)))

    def clean_broken_links(self, fonts_dir):
        """Remove broken symlinks from ``fonts_dir`` for uninstalled fonts."""
        print("Clean up symlinks for uninstalled fonts")
        # dirs are the symlinks to the work_dir directories.
        for entry in os.listdir(fonts_dir):
            path = os.path.join(fonts_dir, entry)
            # Check for broken symlinks.
            if not os.path.exists(path) and os.path.lexists(path):
                os.remove(path)
                print("  Remove symlink {}.".format(reduceuser(path)))


def main(argv=None):
    """Main console-script entry point for ``googlefonts-installer``."""
    parser = argparse.ArgumentParser(
        description=textwrap.dedent(
            GoogleFontInstaller.__doc__.replace('``', "'")),
        formatter_class=argparse.RawDescriptionHelpFormatter)

    # --version
    parser.add_argument('--version', action='version', version=__version__)

    parser.add_argument(
        '-w', '--work-dir',
        action='store',
        default=os.getcwd(),
        help="working directory for Git clone (default .)")
    parser.add_argument(
        '-f', '--fonts-dir',
        action='store',
        default=os.path.expanduser('~/.fonts'),
        help="user's font directory (default ~/.fonts)")
    parser.add_argument(
        '-c', '--config',
        action='store',
        default=os.path.join(os.getcwd(), 'googlefonts.conf'),
        help="configuration file (default ./googlefonts.conf)")

    try:
        if argv is None:  # pragma: no cover
            argv = sys.argv
        args = parser.parse_args(argv[1:])
        gfi = GoogleFontInstaller(
            work_dir=args.work_dir,
            fonts_dir=args.fonts_dir,
            config_path=args.config)
        gfi()
        parser.exit(0)

    except KeyboardInterrupt:
        parser.exit(1, "\nExecution cancelled.")


def reduceuser(path):
    """Replace absolute ``$HOME`` value in ``path`` with ``~``."""
    home = os.path.expanduser('~')
    return path.replace(home, '~', 1)
