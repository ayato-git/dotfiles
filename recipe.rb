{
  "files/zshenv"        => ".zshenv",
  "files/zshrc"         => ".zshrc",
  "files/Brewfile"      => ".Brewfile",
  "files/tool-versions" => ".tool-versions",
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

execute 'install packages from Brewfile' do
  command "brew bundle --global"
  not_if 'brew bundle check --global'
end

execute 'Clean up files needed only during installation' do
  command "brew autoremove && brew cleanup"
  only_if 'which brew'
  not_if 'brew bundle check --global'
end

{
  "php"      => "php:8.2-cli-alpine",
  "composer" => "composer",
  "yt-dlp"   => "jauderho/yt-dlp"
}.each do |name, image|
  execute "install #{name} via Whalebrew" do
    command "whalebrew install --name #{name} #{image}"
    only_if 'docker container ls'
  end
end


# adjust mode for zsh completion
directory '/usr/local/share/zsh' do
  mode '0755'
end

directory '/usr/local/share/zsh/site-functions' do
  mode '0755'
end

execute 'install tools in ~/.tool-versions' do
  command 'RTX_YES=yes rtx install'
  only_if 'which rtx'
end
