{ ... }:
{
    zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 80;
        priority = 100;
    };
    boot.kernel.sysctl."vm.swappiness" = 100;
}
