home_dir = ENV['HOME']
dotfiles_dir = "#{Dir.pwd}"

# create symbolic link.
dotfiles = {
  "files/gitignore" => ".gitignore",
  "files/gitconfig" => ".gitconfig",
  "files/zshenv" => ".zshenv",
  "files/zshrc" => ".zshrc",
  "files/Brewfile" => ".Brewfile",
  "config" => ".config"
}

dotfiles.each do |src, dst|
  src_path = File.join(dotfiles_dir, src)
  dst_path = File.join(home_dir, dst)

  link dst_path do
    to src_path
  end
end

# setup Homebrew
execute 'install homebrew' do
  command '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  not_if 'which brew'
end

execute 'install packages from Brewfile' do
  command "brew bundle --global"
end

execute 'brew autoremove && brew cleanup' do
  only_if 'which brew'
end

# adjust mode for zsh completion
directory '/usr/local/share/zsh' do
  mode '0755'
end

directory '/usr/local/share/zsh/site-functions' do
  mode '0755'
end
