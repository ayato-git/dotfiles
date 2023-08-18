# create symbolic link.
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
  not_if 'brew bundle check --global'
end

execute 'brew autoremove && brew cleanup' do
  only_if 'which brew'
  not_if 'brew bundle check --global'
end

# adjust mode for zsh completion
directory '/usr/local/share/zsh' do
  mode '0755'
end

directory '/usr/local/share/zsh/site-functions' do
  mode '0755'
end

# setup asdf to manage multiple versions of tools
# TODO: asdfが環境変数を読むので、完全な新規環境では期待と異なる動作になる
# TODO: zshenvに書いた環境変数の値を新規環境でも適用したい
File.open('files/tool-versions') do |file|
  file.each_line do |line|
    tool, version = line.chomp.split(' ')

    execute "asdf plugin add #{tool}" do
      not_if "asdf plugin list | grep #{tool}"
    end

    execute "asdf install #{tool} #{version}" do
      not_if "asdf list #{tool} | grep #{version}"
    end

    execute "asdf global #{tool} #{version}" do
      not_if "asdf current #{tool} | grep #{version}"
    end

    execute "asdf reshim #{tool}" do
    end
  end
end
