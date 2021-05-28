{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cCaoozbyfqR9oUKa0h4QoxMp3WzffuQOp+dt1HM8gd4=";
  };

  cargoHash = "sha256-YuowbpZDMwd0bHwOM4KyFsbYWxPBbwWuO0pQpg+zJN4=";

  meta = with lib; {
    description = "A hackable, minimal fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.jpas ];
  };
}
