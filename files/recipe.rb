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
  command "brew bundle --global && brew autoremove && brew cleanup"
  not_if 'brew bundle check --global'
end

# {
#   "yt-dlp"   => "jauderho/yt-dlp"
# }.each do |name, image|
#   execute "install #{name} via Whalebrew" do
#     command "whalebrew install --name #{name} #{image}"
#     only_if 'which docker && which whalebrew && docker container ls'
#     not_if "which #{name}"
#   end
# end

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
  command 'npm uninstall --global npm pnpm yarn || rm -f $(mise which npm)'
  not_if 'which npm && cat $(which npm) | grep corepack'
end

['npm', 'pnpm', 'yarn'].each do |n|
  # TODO: corepackが新しいnodeで実行される様にする
  # config/mise/config.toml で node@latest としてる時に、
  # 直前の 'install tools in config/mise/config.toml' で新しいnodeがインストールされると、
  # mitamaeのプロセス内では古いnodeの上でcorepackコマンドが走ることになる

  execute "replace #{n} with corepack that bundled with Node.js installed via mise" do
    command "corepack enable #{n}"
    only_if 'which corepack | grep "mise" '
    not_if "which #{n} && cat $(which #{n}) | grep corepack "
  end

  execute "activate #{n} via corepack" do
    command "echo y | #{n} -v"
  end
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

execute 'install aws-mfa via pipx' do
  command 'pipx install aws-mfa'
end

# {
#   "wezterm shell-completion --shell zsh" => "_wezterm"
# }.each do |src, dump|
#   execute "add #{dump} for zsh completion" do
#     command "#{src} >> #{brew_prefix}/share/zsh/site-functions/#{dump}"
#     not_if "test -f #{brew_prefix}/share/zsh/site-functions/#{dump}" 
#   end
# end

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

define :macOS_defaults, domain: nil, type: 'int', value: 1 do
  execute params[:name] do
    not_if "defaults read #{params[:domain]} | grep #{params[:value]}"
    command "defaults write #{params[:domain]} -#{params[:type]} #{params[:value]}"
  end
end

macOS_defaults '書類を開く時に常に新しいタブで開く' do
  domain '-globalDomain AppleWindowTabbingMode'
  type 'string'
  value 'always'
end

macOS_defaults '書類を閉じる時に変更内容を保持するかどうかを確認' do
  domain '-globalDomain NSCloseAlwaysConfirmsChanges'
end

macOS_defaults 'Finder等のサイドバーのアイコンのサイズ(大)' do
  domain '-globalDomain NSTableViewDefaultSizeMode'
  value 3
end

macOS_defaults 'トラックパッドの軌跡の速さ' do
  domain '-globalDomain com.apple.trackpad.scaling'
  value 3
end

macOS_defaults 'メニューバーを自動的に表示/非表示 (フルスクリーン時のみ)' do
  domain '-globalDomain AppleMenuBarVisibleInFullscreen'
  value 0
end

macOS_defaults 'Siriをステータスバーに表示しない' do
  domain 'com.apple.Siri StatusMenuVisible'
  value 0
end

macOS_defaults 'バッテリー残量をステータスバーに表示しない' do
  domain 'com.apple.controlcenter "NSStatusItem Visible Battery"'
  value 0
end

macOS_defaults 'AirDropをステータスバーに表示しない' do
  domain 'com.apple.controlcenter "NSStatusItem Visible AirDrop"'
  value 0
end

macOS_defaults 'ステージマネージャーをステータスバーに表示しない' do
  domain 'com.apple.controlcenter "NSStatusItem Visible StageManager"'
  value 0
end

macOS_defaults 'Wi-Fiをステータスバーに表示しない' do
  domain 'com.apple.controlcenter "NSStatusItem Visible WiFi"'
  value 0
end

macOS_defaults 'テキスト入力メニューをステータスバーに表示しない' do
  domain 'com.apple.TextInputMenu "visible"'
  value 0
end

macOS_defaults 'TimeMachineをステータスバーに表示する' do
  domain 'com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine"'
end

macOS_defaults 'VPN構成をステータスバーに表示する' do
  domain 'com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.vpn"'
end

macOS_defaults 'メニューバーの時計に日付を表示しない' do
  domain 'com.apple.menuextra.clock ShowDate'
  value 2
end

macOS_defaults 'メニューバーの時計に秒数を表示' do
  domain 'com.apple.menuextra.clock ShowSeconds'
end

macOS_defaults 'Dockを自動的に隠す' do
  domain 'com.apple.dock autohide'
end

macOS_defaults '隠れたDockを表示するまでの遅延を無くす' do
  domain 'com.apple.dock autohide-delay'
  value 0
end

macOS_defaults 'Dockを拡大する' do
  domain 'com.apple.dock magnification'
end

macOS_defaults 'Dockを拡大した時のサイズを指定' do
  domain 'com.apple.dock largesize'
  value 192
end

macOS_defaults 'ステージマネージャ有効化' do
  domain 'com.apple.WindowManager GloballyEnabled'
end

macOS_defaults '最近使用したアプリをステージマネージャに表示しない (ステージマネージャのサムネイルを自動的に隠す)' do
  domain 'com.apple.WindowManager AutoHide'
end

macOS_defaults 'スクリーンショットの影をなくす' do
  domain 'com.apple.screencapture disable-shadow'
end

macOS_defaults '隠しファイルを常にファインダーに表示する' do
  domain 'com.apple.finder AppleShowAllFiles'
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
