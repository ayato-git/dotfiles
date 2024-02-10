brew_prefix = `uname -m`.include?("arm64") ? '/opt/homebrew' : '/usr/local'

{
  "files/dnscrypt-proxy.toml" => File.join(brew_prefix, '/etc/dnscrypt-proxy.toml'),
  "files/zshenv"        => File.join(ENV['HOME'], ".zshenv"),
  "files/zshrc"         => File.join(ENV['HOME'], ".zshrc"),
  "files/Brewfile"      => File.join(ENV['HOME'], ".Brewfile"),
  "config"              => File.join(ENV['HOME'], ".config")
}
.each do |src, dst|
  src = File.join("#{Dir.pwd}", src)

  link dst do # create symbolic link.
    to src
  end
end

execute 'install homebrew' do
  command '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  not_if 'which brew'
end

execute 'install packages from files/Brewfile' do
  command "brew bundle --global"
  not_if 'brew bundle check --global'
end

execute 'Clean up files needed only during installation' do
  command "brew autoremove & brew cleanup"
  not_if 'brew bundle check --global'
end

{
  "yt-dlp"   => "jauderho/yt-dlp"
}.each do |name, image|
  execute "install #{name} via Whalebrew" do
    command "whalebrew install --name #{name} #{image}"
    only_if 'which docker && which whalebrew && docker container ls'
    not_if "which #{name}"
  end
end

# adjust mode for zsh completion
directory "#{brew_prefix}/share/zsh" do
  mode '0755'
end

directory "#{brew_prefix}/share/zsh/site-functions" do
  mode '0755'
end

execute 'install tools in config/mise/config.toml' do
  command 'mise --yes install'
  only_if 'which mise && mise list | grep "missing" '
end

execute 'remove default npm that bundled with Node.js installed via mise' do
  # 'npm uninstall --global npm' でnpmが消せない。node14と18で確認したがnode20では起きない
  # npm が消せない場合は直接rmで消す
  command 'rm -f $(mise which npm)'
  not_if 'npm uninstall --global npm pnpm yarn'
end

execute 'enable corepack that bundled with Node.js installed via mise' do
  # TODO: corepackが新しいnodeで実行される様にする
  # config/mise/config.toml で node@latest としてる時に、
  # 直前の 'install tools in config/mise/config.toml' で新しいnodeがインストールされると、
  # mitamaeのプロセス内では古いnodeの上でcorepackコマンドが走ることになる
  command "corepack enable npm pnpm yarn"
  only_if 'which corepack | grep "mise" '
  not_if 'which pnpm && cat $(which pnpm) | grep "corepack" '
end

{
  "wezterm shell-completion --shell zsh" => "_wezterm"
}.each do |src, dump|
  execute "add #{dump} for zsh completion" do
    command "#{src} >> #{brew_prefix}/share/zsh/site-functions/#{dump}"
    not_if "test -f #{brew_prefix}/share/zsh/site-functions/#{dump}" 
  end
end

execute 'download phpactor.phar' do
  command 'curl -Lo /usr/local/bin/phpactor https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar'
  not_if 'which phpactor'
end

file '/usr/local/bin/phpactor' do
  action :create
  mode '0755'
end

execute 'start dnscrypt-proxy' do
  command 'sudo brew services restart dnscrypt-proxy'
end
