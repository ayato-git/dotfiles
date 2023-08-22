{
  "files/zshenv"        => ".zshenv",
  "files/zshrc"         => ".zshrc",
  "files/Brewfile"      => ".Brewfile",
  "config"              => ".config"
}
.each do |src, dst|
  src_path = File.join("#{Dir.pwd}", src)
  dst_path = File.join(ENV['HOME'], dst)

  link dst_path do # create symbolic link.
    to src_path
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
  "php"      => "php:8.2-cli-alpine",
  "composer" => "composer",
  "yt-dlp"   => "jauderho/yt-dlp"
}.each do |name, image|
  execute "install #{name} via Whalebrew" do
    command "whalebrew install --name #{name} #{image}"
    only_if 'which docker && which whalebrew && docker container ls'
  end
end


# adjust mode for zsh completion
directory '/usr/local/share/zsh' do
  mode '0755'
end

directory '/usr/local/share/zsh/site-functions' do
  mode '0755'
end

execute 'install tools in config/rtx/config.toml' do
  command 'rtx --yes install'
  only_if 'which rtx && rtx list | grep "missing|outdated" '
end

execute 'enable corepack that bundled with Node.js installed via rtx' do
  command 'corepack enable'
  only_if 'which corepack | grep "rtx" '
  not_if 'which pnpm && cat $(which pnpm) | grep "corepack" '
end

{
  "wezterm shell-completion --shell zsh" => "_wezterm"
}.each do |src, dump|
  execute "add #{dump} for zsh completion" do
    command "#{src} >> /usr/local/share/zsh/site-functions/#{dump}"
    not_if "test -f /usr/local/share/zsh/site-functions/#{dump}" 
  end
end
