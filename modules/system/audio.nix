 { ... }:
#audio conf
{ 
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    audio.enable = true;
    jack.enable = true;
    alsa  = {
      enable = true;
    };
  };

  #turns off pulseaudio
  services.pulseaudio.enable = false;

  #real time audio
  security.rtkit.enable = true;
}
