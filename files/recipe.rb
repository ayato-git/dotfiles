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

{
  "templates/gitconfig.erb"  => "config/git/config",
  "templates/miseconfig.erb" => "config/mise/config.toml"
}
.each do |tmpl, dst|
  template dst do
    source tmpl
    variables(
      usr_home: ENV['HOME'],
      brew_prefix: brew_prefix
    )
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
  "vscode-langservers-extracted"      => "pnpm install --global",
  "cssmodules-language-server"        => "pnpm install --global",
  "stylelint-lsp"                     => "pnpm install --global",
  "@tailwindcss/language-server"      => "pnpm install --global",
  "quick-lint-js"                     => "pnpm install --global",
  "typescript"                        => "pnpm install --global",
  "typescript-language-server"        => "pnpm install --global",
  "svelte-language-server"            => "pnpm install --global",
  "bash-language-server"              => "pnpm install --global",
  "dockerfile-language-server-nodejs" => "pnpm install --global",
  "intelephense"                      => "pnpm install --global",
  "vim-language-server"               => "pnpm install --global",
  "sql-language-server"               => "pnpm install --global",
  "marksman"            => "brew install",
  "lua-language-server" => "brew install"
}.each do |ls, method|

  case method
  when "brew install"
    checker = "brew list | grep "
  when "pnpm install --global"
    checker = "pnpm ls --global | grep "
  end

  execute "install LanguageServer / #{ls}" do
    not_if "#{checker} #{ls}"
    command "#{method} #{ls}"
  end
end

{
  "wezterm shell-completion --shell zsh" => "_wezterm"
}.each do |src, dump|
  execute "add #{dump} for zsh completion" do
    command "#{src} >> #{brew_prefix}/share/zsh/site-functions/#{dump}"
    not_if "test -f #{brew_prefix}/share/zsh/site-functions/#{dump}" 
  end
end

execute 'start dnscrypt-proxy' do
  not_if 'sudo brew services info dnscrypt-proxy'
  command 'sudo brew services restart dnscrypt-proxy'
end

execute 'dnscrypt-proxyをWi-Fi環境下のDNSサーバーとして利用' do
  not_if 'networksetup -getdnsservers Wi-Fi | grep "127.0.0.1"'
  command 'networksetup -setdnsservers Wi-Fi 127.0.0.1'
end

execute 'install security software' do
  not_if 'ls /Applications/*/Antivirus*'
  command 'brew install --cask malwarebytes && sudo mas install 500154009'
end

execute '書類を開く時に常に新しいタブで開く' do
  not_if 'defaults read -globalDomain AppleWindowTabbingMode | grep always'
  command 'defaults write -globalDomain AppleWindowTabbingMode -string "always"'
end

execute '書類を閉じる時に変更内容を保持するかどうかを確認' do
  not_if 'defaults read -globalDomain NSCloseAlwaysConfirmsChanges | grep 1'
  command 'defaults write -globalDomain NSCloseAlwaysConfirmsChanges -int 1'
end

execute 'Finder等のサイドバーのアイコンのサイズ(大)' do
  not_if 'defaults read -globalDomain NSTableViewDefaultSizeMode | grep 3'
  command 'defaults write -globalDomain NSTableViewDefaultSizeMode -int 3'
end

execute 'トラックパッドの軌跡の速さ' do
  not_if 'defaults read -globalDomain com.apple.trackpad.scaling | grep 3'
  command 'defaults write -globalDomain com.apple.trackpad.scaling -int 3'
end

execute 'メニューバーを自動的に表示/非表示 (フルスクリーン時のみ)' do
  not_if 'defaults read -globalDomain AppleMenuBarVisibleInFullscreen | grep 0'
  command 'defaults write -globalDomain AppleMenuBarVisibleInFullscreen -int 0 '
end

execute 'Siriをステータスバーに表示しない' do
  not_if 'defaults read com.apple.Siri StatusMenuVisible | grep 0'
  command 'defaults write com.apple.Siri StatusMenuVisible -int 0'
end

execute 'バッテリー残量をステータスバーに表示しない' do
  not_if 'defaults read com.apple.controlcenter "NSStatusItem Visible Battery" | grep 0'
  command 'defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -int 0'
end

execute 'AirDropをステータスバーに表示しない' do
  not_if 'defaults read com.apple.controlcenter "NSStatusItem Visible AirDrop" | grep 0'
  command 'defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -int 0'
end

execute 'ステージマネージャーをステータスバーに表示しない' do
  not_if 'defaults read com.apple.controlcenter "NSStatusItem Visible StageManager" | grep 0'
  command 'defaults write com.apple.controlcenter "NSStatusItem Visible StageManager" -int 0'
end

execute 'Wi-Fiをステータスバーに表示しない' do
  not_if 'defaults read com.apple.controlcenter "NSStatusItem Visible WiFi" | grep 0'
  command 'defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -int 0'
end

execute 'TimeMachineをステータスバーに表示する' do
  not_if 'defaults read com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" | grep 1'
  command 'defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" -int 1'
end

execute 'VPN構成をステータスバーに表示する' do
  not_if 'defaults read com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.vpn" | grep 1'
  command 'defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.vpn" -int 1'
end

execute 'メニューバーの時計に日付を表示しない' do
  not_if 'defaults read com.apple.menuextra.clock ShowDate | grep 2'
  command 'defaults write com.apple.menuextra.clock ShowDate -int 2'
end

execute 'メニューバーの時計に秒数を表示' do
  not_if 'defaults read com.apple.menuextra.clock ShowSeconds | grep 1'
  command 'defaults write com.apple.menuextra.clock ShowSeconds -int 1'
end

execute 'Dockを自動的に隠す' do
  not_if 'defaults read com.apple.dock autohide | grep 1'
  command 'defaults write com.apple.dock autohide -int 1'
end

execute '隠れたDockを表示するまでの遅延を無くす' do
  not_if 'defaults read com.apple.dock autohide-delay | grep 0'
  command 'defaults write com.apple.dock autohide-delay -int 0'
end

execute 'Dockを拡大する' do
  not_if 'defaults read com.apple.dock magnification | grep 1'
  command 'defaults write com.apple.dock magnification -int 1'
end

execute 'Dockを拡大した時のサイズを指定' do
  not_if 'defaults read com.apple.dock largesize | grep 192'
  command 'defaults write com.apple.dock largesize -int 192'
end

execute 'ステージマネージャ有効化' do
  not_if 'defaults read com.apple.WindowManager GloballyEnabled | grep 1'
  command 'defaults write com.apple.WindowManager GloballyEnabled -int 1'
end

execute '最近使用したアプリをステージマネージャに表示しない (ステージマネージャのサムネイルを自動的に隠す)' do
  not_if 'defaults read com.apple.WindowManager AutoHide | grep 1'
  command 'defaults write com.apple.WindowManager AutoHide -int 1'
end

execute 'スクリーンショットの影をなくす' do
  not_if 'defaults read com.apple.screencapture disable-shadow | grep 1'
  command 'defaults write com.apple.screencapture disable-shadow -int 1'
end

execute '隠しファイルを常にファインダーに表示する' do
  not_if 'defaults read com.apple.finder AppleShowAllFiles | grep 1'
  command 'defaults write com.apple.finder AppleShowAllFiles -int 1'
end

# TODO: 一度アプリを開いた後に以下を設定したい
# execute 'finickyの設定ファイルをdotfiles配下から読み込み' do
#   not_if 'defaults read net.kassett.finicky NSNavLastRootDirectory | grep "~/Repositories/github.com/ayato-git/dotfiles/config/finicky"'
#   command 'defaults write net.kassett.finicky NSNavLastRootDirectory -string "~/Repositories/github.com/ayato-git/dotfiles/config/finicky"'
# end
#
# execute 'RunCatに設定ファイルをdotfiles配下から読み込み' do
#   not_if 'defaults read com.kyome.RunCat showBattery | grep 1'
#   command 'defaults write com.kyome.RunCat showBattery -int 1'
# end
