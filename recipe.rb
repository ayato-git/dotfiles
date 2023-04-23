home_dir = ENV['HOME']
dotfiles_dir = "#{Dir.pwd}"

dotfiles = {
  "files/gitignore" => ".gitignore",
  "files/gitconfig" => ".gitconfig",
  "files/zshenv" => ".zshenv",
  "files/zshrc" => ".zshrc",
  "files/Brewfile" => ".Brewfile",
  "config" => ".config"
}

# create symbolic link.
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

execute 'update homebrew' do
  command 'brew update'
end

execute 'upgrade outdated packages' do
  command 'brew upgrade'
end

execute 'install packages from Brewfile' do
  command "brew bundle --global"
end
