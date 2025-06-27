# Linux (Debian-based) specific configuration recipe

# Dotfiles and configuration symlinks (shared with macOS)
{
  "files/zshenv"        => File.join(ENV['HOME'], ".zshenv"),
  "files/zshrc"         => File.join(ENV['HOME'], ".zshrc"),
  "config"              => File.join(ENV['HOME'], ".config")
}
.each do |src, dst|
  src = File.join("#{Dir.pwd}", src)

  link dst do
    to src
  end
end

# Template files for Linux
{
  "templates/gitconfig.erb"  => "config/git/config",
  "templates/miseconfig.erb" => "config/mise/config.toml"
}
.each do |tmpl, dst|
  template dst do
    source tmpl
    variables(
      usr_home: ENV['HOME'],
      brew_prefix: "/usr/local"  # Default for Linux
    )
  end
end

# Update package lists
execute 'update apt package lists' do
  command 'sudo apt update'
end

# Install packages from apt-manual.txt
apt_packages_file = File.join(Dir.pwd, 'packages/apt-manual.txt')

if File.exist?(apt_packages_file)
  File.readlines(apt_packages_file).each do |line|
    pkg = line.strip
    next if pkg.empty? || pkg.start_with?('#')

    package pkg do
      action :install
    end
  end
end

# Install flatpak packages
execute 'install flatpak packages' do
  command 'flatpak install -y flathub $(cat packages/flatpak.txt | tr "\n" " ")'
  only_if 'test -f packages/flatpak.txt && which flatpak'
end

# # Install Snap packages (optional)
# execute 'install essential snap packages' do
#   command 'sudo snap install code --classic'
#   only_if 'which snap'
#   not_if 'snap list | grep code'
# end
# 
# # Install mise for tool management
# execute 'install mise' do
#   command 'curl https://mise.run | sh'
#   not_if 'which mise'
# end
# 
# # Source mise in current shell for subsequent commands
# execute 'source mise in bashrc' do
#   command 'echo \'eval "$(~/.local/bin/mise activate bash)"\' >> ~/.bashrc'
#   not_if 'grep -q "mise activate" ~/.bashrc'
# end
# 
# # Install tools via mise
# execute 'install tools in config/mise/config.toml' do
#   command '~/.local/bin/mise --yes install'
#   only_if 'test -f ~/.local/bin/mise && test -f config/mise/config.toml'
# end
# 
# # Install Node.js tools globally
# execute 'install nodejs and npm via mise' do
#   command '~/.local/bin/mise install node@latest'
#   only_if 'test -f ~/.local/bin/mise'
#   not_if '~/.local/bin/mise list node 2>/dev/null | grep -q node'
# end
# 
# # Setup corepack for npm alternatives
# execute 'enable corepack' do
#   command 'corepack enable'
#   only_if 'which corepack'
# end

# Language servers installation for Linux
# {
#   "vscode-langservers-extracted"      => "npm install -g",
#   "cssmodules-language-server"        => "npm install -g",
#   "stylelint-lsp"                     => "npm install -g",
#   "@tailwindcss/language-server"      => "npm install -g",
#   "quick-lint-js"                     => "npm install -g",
#   "typescript"                        => "npm install -g",
#   "typescript-language-server"        => "npm install -g",
#   "svelte-language-server"            => "npm install -g",
#   "bash-language-server"              => "npm install -g",
#   "dockerfile-language-server-nodejs" => "npm install -g",
#   "intelephense"                      => "npm install -g",
#   "vim-language-server"               => "npm install -g",
#   "sql-language-server"               => "npm install -g"
# }.each do |ls, method|
#   execute "install LanguageServer / #{ls}" do
#     command "#{method} #{ls}"
#     only_if 'which npm'
#     not_if "npm list -g #{ls}"
#   end
# end
# 
# # Install language servers via apt (if available)
# {
#   "lua-language-server" => "lua-language-server"
# }.each do |name, package|
#   execute "install #{name} via apt" do
#     command "sudo apt install -y #{package}"
#     not_if "which #{name}"
#   end
# end
# 
# # Install pipx and Python tools
# execute 'install pipx' do
#   command 'sudo apt install -y pipx'
#   not_if 'which pipx'
# end
# 
# execute 'ensure pipx path' do
#   command 'pipx ensurepath'
#   only_if 'which pipx'
# end
# 
# execute 'install aws-mfa via pipx' do
#   command 'pipx install aws-mfa'
#   only_if 'which pipx'
#   not_if 'pipx list | grep aws-mfa'
# end
# 
# # Install additional development tools
# execute 'install additional development tools' do
#   command 'sudo apt install -y neovim htop tree curl wget git git-lfs build-essential'
#   not_if 'dpkg -l | grep -E "neovim|htop|tree|curl|wget|git|build-essential"'
# end
# 
# # Install Docker (if not already installed)
# execute 'install docker' do
#   command <<-EOF
#     curl -fsSL https://get.docker.com -o get-docker.sh
#     sudo sh get-docker.sh
#     sudo usermod -aG docker $USER
#     rm get-docker.sh
#   EOF
#   not_if 'which docker'
# end
# 
# # Setup zsh as default shell
# execute 'install zsh' do
#   command 'sudo apt install -y zsh'
#   not_if 'which zsh'
# end
# 
# execute 'change default shell to zsh' do
#   command 'chsh -s $(which zsh)'
#   not_if 'echo $SHELL | grep zsh'
# end
# 
# # Install oh-my-zsh or similar (optional)
# execute 'install oh-my-zsh' do
#   command 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
#   not_if 'test -d ~/.oh-my-zsh'
# end
# 
# # Setup flatpak flathub repository
# execute 'add flathub repository' do
#   command 'flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo'
#   only_if 'which flatpak'
#   not_if 'flatpak remotes | grep flathub'
# end
