home_dir = ENV['HOME']
dotfiles_dir = "#{Dir.pwd}"

dotfiles = {
  "gitignore" => ".gitignore",
  "gitconfig" => ".gitconfig",
  "vimrc" => ".vimrc",
  "vim" => ".vim",
  "config" => ".config"
}

dotfiles.each do |src, dst|
  src_path = File.join(dotfiles_dir, src)
  dst_path = File.join(home_dir, dst)

  link dst_path do
    to src_path
  end
end
