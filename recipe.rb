home_dir = ENV['HOME']
dotfiles_dir = "#{Dir.pwd}"

dotfiles = {
  "files/gitignore" => ".gitignore",
  "files/gitconfig" => ".gitconfig",
  "files/zshenv" => ".zshenv",
  "files/zshrc" => ".zshrc",
  "config" => ".config"
}

dotfiles.each do |src, dst|
  src_path = File.join(dotfiles_dir, src)
  dst_path = File.join(home_dir, dst)

  link dst_path do
    to src_path
  end
end
