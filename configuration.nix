# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Support Data Disk
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/data" = 
  { device ="/dev/sdb1";
    fsType = "ntfs";
    options = [ "rw" "uid=1000"];
  };

  networking.hostName = "t470"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Networking 
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim neofetch unzip tmux
    vscode git dmenu 
    python python3
    google-chrome firefox
    powertop
    mpv qbittorrent
    undervolt
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-cjk
    liberation_ttf
    hack-font
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";
  services.xserver.config=''
    Section "InputClass"
      Identifier "mouse accel"
      Driver "libinput"
      MatchIsPointer "on"
      Option "AccelProfile" "flat"
      Option "AccelSpeed" "0"
    EndSection
  '';

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable zsh
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "candy";
  };

  # Gnome Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.blerpu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

  # Enable OpenGL Drivers
  hardware.opengl.enable = true;

  # Enable Sway
  # programs.sway.enable = true;

  # Enable TLP
  services.tlp.enable = true;

  # Set TLP Settings
  services.tlp.extraConfig = ''
  START_CHARGE_THRESH_BAT0=80
  STOP_CHARGE_THRESH_BAT0=85
  START_CHARGE_THRESH_BAT1=80
  STOP_CHARGE_THRESH_BAT1=85
  '';

  # Enable Undervolt
  services.undervolt = {
    enable = true;
    coreOffset = "-100";
    gpuOffset = "-80";
    uncoreOffset = "-100";
    analogioOffset = "0";
  };

  # Flatpak
  services.flatpak.enable = true;

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # virtualization
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "blerpu" ];
}

